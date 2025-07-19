#!/usr/bin/env python3
"""
One-file metadata generator for ChetasVault.
Produces file_metadata.json + history/daily_YYYY-MM-DD.json
OPTIMIZED: Only processes changed/new files, reuses existing metadata for unchanged files.
"""
import os
import json
import re
import subprocess
from datetime import datetime
from pathlib import Path

# pip install google-generativeai
import google.generativeai as genai

###############################################################################
# CONFIG
###############################################################################
ROOT_DIR = Path(__file__).resolve().parent
HISTORY_DIR = ROOT_DIR / "history"
HISTORY_DIR.mkdir(exist_ok=True)
METADATA_FILE = ROOT_DIR / "file_metadata.json"

GEMINI_KEY = os.getenv("GEMINI_API_KEY")
if GEMINI_KEY:
    genai.configure(api_key=GEMINI_KEY)
    MODEL = genai.GenerativeModel("gemini-2.0-flash-exp")

EXTENSIONS = {".html", ".md", ".txt"}
CREATION_PROMPT_RE = re.compile(r"CREATION PROMPT:\s*```(.*?)```", re.S | re.I)
CODE_BLOCK_RE = re.compile(r"```[\s\S]*?```")

###############################################################################
# HELPERS
###############################################################################
def load_existing_metadata():
    """Load existing metadata file if it exists."""
    if METADATA_FILE.exists():
        try:
            with open(METADATA_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                # Convert list to dict keyed by filename for faster lookup
                return {record['filename']: record for record in data}
        except (json.JSONDecodeError, KeyError, TypeError):
            print("⚠️ Existing metadata file corrupted, rebuilding from scratch")
            return {}
    return {}

def git_dates(path: Path):
    """Return (created_iso, last_modified_iso) via git log."""
    try:
        created = subprocess.check_output(
            ["git", "log", "--diff-filter=A", "--format=%ai", "--", path],
            text=True, stderr=subprocess.DEVNULL
        ).splitlines()[-1].strip()
    except (subprocess.CalledProcessError, IndexError):
        created = None

    try:
        modified = subprocess.check_output(
            ["git", "log", "-1", "--format=%ai", "--", path],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        modified = None

    return created, modified

def extract_tags(content: str):
    m = re.search(r"^---.*?tags:\s*\[(.*?)\]", content, re.S | re.M)
    if m:
        return [t.strip() for t in m.group(1).split(",") if t.strip()]
    return []

def extract_type(content: str):
    m = re.search(r"^---.*?type:\s*(\w+)", content, re.S | re.M)
    return m.group(1) if m else "prose"

def summarize(text: str) -> str:
    if not GEMINI_KEY:
        return "No summary."
    try:
        prompt = f"Summarize in ≤ 50 words:\n{text[:1000]}"
        return MODEL.generate_content(prompt).text.strip()
    except Exception as e:
        print(f"⚠️ Summary generation failed: {e}")
        return "Summary unavailable."

def file_needs_processing(fpath: Path, existing_record: dict) -> bool:
    """Check if file needs to be processed based on modification time and size."""
    try:
        stat = fpath.stat()
        current_mtime = datetime.fromtimestamp(stat.st_mtime).isoformat()
        current_size = stat.st_size
        
        # File needs processing if:
        # 1. No existing record
        # 2. Modification time changed
        # 3. File size changed
        return (
            not existing_record or 
            existing_record.get('modified_time') != current_mtime or
            existing_record.get('file_size') != current_size
        )
    except (OSError, KeyError):
        return True  # Process if we can't determine, to be safe

def process_file(fpath: Path) -> dict:
    """Process a single file and return its metadata record."""
    stat = fpath.stat()
    content = fpath.read_text(encoding="utf-8", errors="ignore")
    created, modified = git_dates(fpath)
    
    if not created:
        created = datetime.fromtimestamp(stat.st_ctime).isoformat()
    if not modified:
        modified = datetime.fromtimestamp(stat.st_mtime).isoformat()

    word_count = len(re.findall(r"\w+", content))
    code_blocks = len(CODE_BLOCK_RE.findall(content))
    creation_prompt = CREATION_PROMPT_RE.search(content)
    creation_prompt = creation_prompt.group(1).strip() if creation_prompt else None
    tags = extract_tags(content)
    work_type = extract_type(content)
    work_minutes = max(
        int(
            (datetime.fromisoformat(modified) - datetime.fromisoformat(created))
            .total_seconds()
            / 60
        ),
        0,
    )

    mtime = datetime.fromisoformat(modified)
    return {
        "filename": str(fpath.relative_to(ROOT_DIR)),
        "display_name": fpath.stem.replace("_", " ").replace("-", " "),
        "category": tags[0] if tags else "Other",
        "tags": tags,
        "type": work_type,
        "file_size": stat.st_size,
        "word_count": word_count,
        "code_blocks": code_blocks,
        "creation_prompt": creation_prompt,
        "work_minutes": work_minutes,
        "creation_time": created,
        "modified_time": modified,
        "hour_of_day": mtime.hour,
        "day_of_week": mtime.weekday(),
        "summary": summarize(content),
        "url": f"https://<your-github-user>.github.io/ChetasVault/{fpath.name}",
    }

###############################################################################
# MAIN
###############################################################################
def main():
    # Load existing metadata
    existing_metadata = load_existing_metadata()
    processed_files = set()
    api_calls = 0
    reused_records = 0
    new_or_updated = 0
    
    print("🔍 Scanning for files...")
    
    # Process all current files
    current_metadata = {}
    for root, _, files in os.walk(ROOT_DIR):
        for fname in files:
            if Path(fname).suffix.lower() not in EXTENSIONS:
                continue
                
            fpath = Path(root) / fname
            relative_path = str(fpath.relative_to(ROOT_DIR))
            processed_files.add(relative_path)
            
            try:
                existing_record = existing_metadata.get(relative_path)
                
                if file_needs_processing(fpath, existing_record):
                    print(f"🔄 Processing: {relative_path}")
                    record = process_file(fpath)
                    current_metadata[relative_path] = record
                    new_or_updated += 1
                    if GEMINI_KEY:  # Only count if we actually made an API call
                        api_calls += 1
                else:
                    print(f"♻️  Reusing: {relative_path}")
                    current_metadata[relative_path] = existing_record
                    reused_records += 1
                    
            except Exception as e:
                print(f"⚠️ Skip {relative_path}: {e}")
                # Try to preserve existing record if processing fails
                if existing_record:
                    current_metadata[relative_path] = existing_record
                    reused_records += 1

    # Remove records for files that no longer exist
    removed_files = set(existing_metadata.keys()) - processed_files
    if removed_files:
        print(f"🗑️  Removed {len(removed_files)} deleted files from metadata")

    # Convert back to list format for output
    metadata_list = list(current_metadata.values())

    # Save outputs
    METADATA_FILE.write_text(
        json.dumps(metadata_list, indent=2), encoding="utf-8"
    )
    
    daily_file = HISTORY_DIR / f"daily_{datetime.utcnow().strftime('%Y-%m-%d')}.json"
    daily_file.write_text(json.dumps(metadata_list, indent=2), encoding="utf-8")
    
    # Summary
    total_files = len(metadata_list)
    print(f"\n✅ Generated metadata for {total_files} files:")
    print(f"   📊 {new_or_updated} files processed (new/updated)")
    print(f"   ♻️  {reused_records} files reused (unchanged)")
    if removed_files:
        print(f"   🗑️  {len(removed_files)} files removed")
    print(f"   🤖 {api_calls} API calls made")
    
    if api_calls == 0 and new_or_updated > 0:
        print("   💡 No API calls made (GEMINI_API_KEY not set)")

if __name__ == "__main__":
    main()