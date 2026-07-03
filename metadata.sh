#!/bin/bash

# Create output directory
mkdir -p metadata_output

# Initialize JSON file
echo '{"files": [' > metadata_output/file_metadata.json

# Process each file
first_file=true
for file in *.html *.md *.ini LICENSE README.md; do
    if [ -f "$file" ]; then
        # Add comma separator for JSON
        if [ "$first_file" = false ]; then
            echo ',' >> metadata_output/file_metadata.json
        fi
        first_file=false
        
        # Get file stats
        file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        creation_time=$(stat -c%W "$file" 2>/dev/null || stat -f%B "$file" 2>/dev/null)
        modification_time=$(stat -c%Y "$file" 2>/dev/null || stat -f%m "$file" 2>/dev/null)
        access_time=$(stat -c%X "$file" 2>/dev/null || stat -f%a "$file" 2>/dev/null)
        
        # Convert timestamps to readable format
        creation_date=$(date -d @"$creation_time" 2>/dev/null || date -r "$creation_time" 2>/dev/null)
        modification_date=$(date -d @"$modification_time" 2>/dev/null || date -r "$modification_time" 2>/dev/null)
        access_date=$(date -d @"$access_time" 2>/dev/null || date -r "$access_time" 2>/dev/null)
        
        # Calculate time between creation and last edit
        time_diff=$((modification_time - creation_time))
        days_diff=$((time_diff / 86400))
        hours_diff=$(((time_diff % 86400) / 3600))
        
        # Get file extension and type
        extension="${file##*.}"
        mime_type=$(file -b --mime-type "$file" 2>/dev/null || echo "unknown")
        
        # Count lines
        line_count=$(wc -l < "$file" 2>/dev/null || echo 0)
        
        # Extract content snippets
        top_10=$(head -n 10 "$file" 2>/dev/null | sed 's/"/\\"/g' | tr '\n' '\\n')
        middle_start=$((line_count / 2 - 5))
        middle_end=$((line_count / 2 + 5))
        middle_10=$(sed -n "${middle_start},${middle_end}p" "$file" 2>/dev/null | sed 's/"/\\"/g' | tr '\n' '\\n')
        bottom_10=$(tail -n 10 "$file" 2>/dev/null | sed 's/"/\\"/g' | tr '\n' '\\n')
        
        # Extract title from HTML files
        title=""
        if [[ "$extension" == "html" ]]; then
            title=$(grep -i "<title>" "$file" | sed 's/<[^>]*>//g' | sed 's/^[ \t]*//' | sed 's/[ \t]*$//' | head -1)
        fi
        
        # Get word count for text files
        word_count=$(wc -w < "$file" 2>/dev/null || echo 0)
        
        # Estimate reading time (average 200 words per minute)
        reading_time_minutes=$((word_count / 200))
        if [ $reading_time_minutes -eq 0 ]; then
            reading_time_minutes=1
        fi
        
        # Generate JSON entry
        cat >> metadata_output/file_metadata.json << EOF
{
    "filename": "$file",
    "title": "$title",
    "file_size": $file_size,
    "file_size_human": "$(numfmt --to=iec --suffix=B $file_size 2>/dev/null || echo "${file_size}B")",
    "extension": "$extension",
    "mime_type": "$mime_type",
    "line_count": $line_count,
    "word_count": $word_count,
    "reading_time_minutes": $reading_time_minutes,
    "creation_time": $creation_time,
    "modification_time": $modification_time,
    "access_time": $access_time,
    "creation_date": "$creation_date",
    "modification_date": "$modification_date",
    "access_date": "$access_date",
    "days_between_creation_and_edit": $days_diff,
    "hours_between_creation_and_edit": $hours_diff,
    "url": "https://yourusername.github.io/OBDistGit/$(echo "$file" | sed 's/ /%20/g')",
    "content_snippets": {
        "top_10_lines": "$top_10",
        "middle_10_lines": "$middle_10",
        "bottom_10_lines": "$bottom_10"
    },
    "git_info": {
        "last_commit": "$(git log -1 --format="%H" -- "$file" 2>/dev/null || echo "unknown")",
        "last_commit_date": "$(git log -1 --format="%ad" --date=iso -- "$file" 2>/dev/null || echo "unknown")",
        "author": "$(git log -1 --format="%an" -- "$file" 2>/dev/null || echo "unknown")",
        "commit_count": "$(git rev-list --count HEAD -- "$file" 2>/dev/null || echo 0)"
    }
}
EOF
    fi
done

# Close JSON array
echo ']}' >> metadata_output/file_metadata.json

# Generate summary statistics
echo "Generating summary statistics..."
cat > metadata_output/summary_stats.json << EOF
{
    "total_files": $(ls -1 *.html *.md *.ini LICENSE README.md 2>/dev/null | wc -l),
    "total_size": "$(du -sh . | cut -f1)",
    "file_types": {
        "html": $(ls -1 *.html 2>/dev/null | wc -l),
        "markdown": $(ls -1 *.md 2>/dev/null | wc -l),
        "config": $(ls -1 *.ini 2>/dev/null | wc -l),
        "other": $(ls -1 LICENSE README.md 2>/dev/null | wc -l)
    },
    "generation_date": "$(date)",
    "repository_info": {
        "current_branch": "$(git branch --show-current 2>/dev/null || echo "unknown")",
        "total_commits": "$(git rev-list --count HEAD 2>/dev/null || echo 0)",
        "last_commit": "$(git log -1 --format="%H" 2>/dev/null || echo "unknown")",
        "last_commit_date": "$(git log -1 --format="%ad" --date=iso 2>/dev/null || echo "unknown")"
    }
}
EOF

echo "Metadata extraction complete! Files generated:"
echo "- metadata_output/file_metadata.json"
echo "- metadata_output/summary_stats.json"