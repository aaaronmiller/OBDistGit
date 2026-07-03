# Modern AI, LLMs, and Agent Harnesses

This primer treats the last decade of AI as a story with three intertwined layers: **models** that got more capable, **interfaces** that made those capabilities legible to ordinary users, and **harnesses** that let models act in the world through tools, memory, files, shells, browsers, and structured workflows. That is the simplest way to understand why “AI” felt like a laboratory curiosity in one era, a chatbot in the next, and a coding/agent platform after that. This framing is a synthesis, but it is strongly supported by the historical sequence of papers and product releases below. citeturn4search0turn34search1turn34search0turn36search0turn35search0turn24view2

## A simple mental model

A novice-friendly but academically faithful way to think about modern AI is:

**Classical deep learning** made pattern recognition powerful.  
**Transformers** made language and sequence modeling general-purpose.  
**Large language models** made one system usable for many tasks through prompting.  
**Instruction tuning and preference tuning** made models follow humans better.  
**Retrieval, tools, and structured outputs** made them more reliable in applications.  
**Agent harnesses** made them able to plan, act, observe, retry, and coordinate over time. citeturn4search0turn34search1turn34search0turn36search2turn25view2turn25view3turn35search0turn24view2

That also explains the main shift in user experience:

- **Before 2020:** you usually trained or fine-tuned a model for a task.  
- **Around 2020–2022:** you increasingly *prompted* a general model.  
- **Around 2022–2024:** you started to *chat* with instruction-following models, ask them to reason step by step, and ground them with retrieved documents.  
- **Around 2023–2026:** you began to *wrap* models in harnesses that give them tools, memory, code execution, browsers, shells, and explicit specs. citeturn34search1turn34search0turn36search7turn36search0turn35search0turn34search2turn24view2turn25view0turn24view3

The topics you named are therefore real, but a few major themes were missing from your list:

**alignment and instruction following**, **tool use and function calling**, **structured outputs**, **prompt injection and agent security**, **evaluation harnesses and benchmarks**, **multimodality**, **long-context engineering**, and **protocols for tool ecosystems such as MCP**. Several of those turned out to matter as much as prompting or RAG in practical systems. citeturn34search0turn36search2turn25view2turn25view3turn15search1turn15search0turn31search0turn31search1turn26view2

## The story of AI

The modern story starts with the **Transformer**. *Attention Is All You Need* replaced recurrence with attention, making models easier to scale and much better at parallel sequence processing. It was an architectural paper, but its downstream social effect was larger: it created the substrate on which general-purpose language models, then chat interfaces, then agents, would be built. citeturn4search0

The next decisive turn was **in-context use**. GPT-3’s paper, *Language Models are Few-Shot Learners*, did not merely describe a bigger model; it showed that a single model could perform many tasks from natural-language instructions and examples, often without gradient updates. That was the birth of prompting as an application paradigm. OpenAI’s 2020 API release then turned that research fact into a product fact: “text in, text out” became a programmable interface. citeturn34search1turn22search0

The third turn was **alignment into dialogue**. Research like *InstructGPT* showed that scaling alone did not guarantee helpfulness, and that reinforcement learning from human feedback could make smaller instruction-following models preferable to much larger base models. Anthropic’s related work on helpful/harmless assistants and later *Constitutional AI* pushed the field toward explicit behavioral steering. This is the research lineage behind today’s ideas of system messages, developer messages, policies, model specs, and “assistant behavior” more generally. citeturn34search0turn36search14turn36search2turn24view0turn26view1

The fourth turn was **reasoning by prompt**. *Chain-of-Thought Prompting* and *Self-Consistency* taught the field that some capabilities were not only “inside the model,” but were unlocked by how the model was prompted and decoded. In other words, usage patterns started to look like capability discoveries. This period also produced the first burst of mass-market “prompt engineering.” citeturn36search7turn36search1turn11search1turn23search0

The fifth turn was **grounding the model outside its weights**. *RAG* provided a general recipe for combining parametric memory with external retrieval, solving two problems at once: freshness and provenance. In practice, this became the default enterprise pattern because it was often cheaper, safer, and easier to update than retraining a model. That is why RAG became not just a research idea but a full product category around vector databases, indexing pipelines, and document-chat systems. citeturn36search0turn23search1turn23search4

The sixth turn was **reason-and-act agents**. *ReAct* made explicit the core loop now found everywhere in agent systems: reason, call a tool or take an action, observe the result, continue. *Toolformer* extended that into the question of when a model should decide to call a tool at all. *Generative Agents*, *Reflexion*, and *MemGPT* pushed further into persistent memory, self-reflection, and long-horizon behavior. By late 2024, Anthropic’s “building effective agents” essay had distilled the industrial lesson: the best real systems were often simple, composable workflows and restrained agents, not magical autonomous beings. citeturn35search0turn34search2turn35search2turn35search1turn34search3turn24view2

The seventh turn was **agentic software engineering**. Once models became strong enough at code, and once CLIs, editors, shells, and file tools were exposed safely enough, “coding agents” emerged as a new harness layer. Today’s Codex CLI, Gemini CLI, Claude tool use, and terminal tools like Aider are not new models in themselves; they are **wrappers around models** that provide repository context, tool schemas, execution environments, and review loops. That is why the right unit of analysis in 2026 is often no longer “Which model?” but “Which model plus which harness?” citeturn25view0turn25view1turn24view3turn26view0turn26view3turn27view2

## The key papers that changed how people use models

The list below is intentionally biased toward **usage breakthroughs**, not only raw architecture.

| Paper | Why it mattered for usage | Representative gateway explainer |
| --- | --- | --- |
| **Language Models are Few-Shot Learners** (Brown et al., 2020) citeturn34search1 | Established prompting and in-context learning as an alternative to task-specific fine-tuning. This is where “write instructions/examples in plain text” became a serious interface idea. citeturn34search1turn22search0 | OpenAI’s API launch page for the original GPT-3 era was the practical gateway from research to application building. citeturn22search0 |
| **Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks** (Lewis et al., 2020) citeturn36search0 | Introduced the canonical “model + retriever + external corpus” pattern that became enterprise RAG. Crucial for freshness, citations, and private knowledge. citeturn36search0 | Pinecone’s RAG explainers became one of the clearest lay on-ramps. citeturn23search1turn23search4 |
| **Training Language Models to Follow Instructions with Human Feedback** (Ouyang et al., 2022) citeturn34search0 | Turned raw LLMs into instruction followers. This is the research ancestor of “chat assistants” and why system/user messages matter in practice. citeturn34search0turn24view0 | OpenAI’s prompt-engineering guide is the practical descendant for developers. citeturn11search1 |
| **Chain-of-Thought Prompting Elicits Reasoning in Large Language Models** (Wei et al., 2022) citeturn36search7 | Showed that prompting style can unlock latent reasoning ability. It created the first major wave of explicit reasoning prompts. citeturn36search7 | DAIR.AI’s Prompting Guide is a strong lay entry point. citeturn23search0 |
| **Self-Consistency Improves Chain of Thought Reasoning in Language Models** (Wang et al., 2022) citeturn36search1 | Demonstrated that decoding strategy is part of system design. Instead of one reasoning path, sample several and marginalize. This is an early precursor to “inference-time compute matters.” citeturn36search1 | Prompting-guide style explainers and vendor prompting docs popularized the idea for practitioners. citeturn23search0turn11search1 |
| **Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022) citeturn36search2 | Important not because users read constitutions, but because it pushed behavior control into explicit principles and critique/revision loops. This influenced policy-aware prompting and public model specs. citeturn36search2turn24view0 | OpenAI’s Model Spec and Anthropic’s system-prompt transparency are the lay descendants of this line of thought. citeturn10search14turn26view1 |
| **ReAct: Synergizing Reasoning and Acting in Language Models** (Yao et al., 2022/2023) citeturn35search0 | The canonical paper for modern agents. Interleaving reasoning with actions became the default design of tool-using agent loops. citeturn35search0turn24view3 | Lilian Weng’s agent essay and Simon Willison’s later explanations made this legible to developers. citeturn27view0turn27view2 |
| **Toolformer: Language Models Can Teach Themselves to Use Tools** (Schick et al., 2023) citeturn34search2 | Made tool use a first-class capability rather than an ad hoc wrapper. It framed calculators, search, translation, and APIs as native parts of the language-model workflow. citeturn34search2turn26view0 | OpenAI’s function-calling announcement and Anthropic tool-use docs were the industry gateway versions. citeturn25view2turn26view0 |
| **Generative Agents** (Park et al., 2023) citeturn35search2 | Seminal for long-term agent memory, reflection, and believable multi-agent behavior. It influenced later memory architectures and “agent society” demos. citeturn35search2 | Lilian Weng’s essay brought its planning-memory-tool triad to a wide technical audience. citeturn27view0 |
| **SWE-agent: Agent-Computer Interfaces Enable Automated Software Engineering** (Yang et al., 2024) citeturn1search11 | The clearest research bridge from LLMs to CLI coding agents. It formalized the idea that models need an interface to repositories, tests, and shell tools to solve real software tasks. citeturn1search11turn31search0 | Simon Willison’s “How coding agents work,” along with Codex CLI and Gemini CLI docs, are the most useful lay gateways here. citeturn27view2turn25view0turn24view3 |

A fair “honorable mentions” list would include **Reflexion** for self-critique and episodic memory, **MemGPT** for external/hierarchical memory, and **Prompt Injection** work for the security turn that agent builders had to learn the hard way. citeturn35search1turn34search3turn15search1turn15search0

## The architectural breakthroughs behind the user experience

The easiest way to connect architecture to user experience is to ask: **what changed in the model or inference stack that users could actually feel?**

| Improvement | What it changed for users | Representative sources and model inflections |
| --- | --- | --- |
| **Transformer self-attention** | Made very large, general language models possible at all. Without this, the later prompt/chat/agent story does not exist. citeturn4search0 | Transformer paper. citeturn4search0 |
| **Scale plus in-context learning** | Enabled one model to do many tasks from plain-language instructions and examples. Prompting became a programming interface. citeturn34search1turn22search0 | GPT-3 paper and OpenAI API launch. citeturn34search1turn22search0 |
| **Instruction tuning, RLHF, and constitutional tuning** | Made models obey user intent more reliably, refuse harmful requests more consistently, and behave like assistants rather than next-token engines. citeturn34search0turn36search14turn36search2 | InstructGPT; Anthropic helpful/harmless and Constitutional AI. citeturn34search0turn36search14turn36search2 |
| **Diffusion and latent diffusion** | On the image side, these made “prompting an AI” culturally mainstream before many people used LLM APIs directly. Latent diffusion reduced cost enough for broad deployment. citeturn5search3turn8search1turn8search0 | DDPM, Latent Diffusion, DALL·E 2. citeturn5search3turn8search1turn8search0 |
| **RoPE and long-context extension methods** | Improved length extrapolation and made very long prompts more practical, which later fed into context engineering and “just give it the repo/docs/transcript” workflows. citeturn6search3turn7search15turn7search7 | RoFormer, Position Interpolation, YaRN. citeturn6search3turn7search15turn7search7 |
| **KV cache** | Reduced token-by-token recomputation during generation, making chat and long sessions responsive enough to feel interactive. citeturn7search8turn7search0 | Hugging Face cache docs; standard transformer decoding practice. citeturn7search8turn7search0 |
| **MQA and GQA** | Shrunk inference bandwidth and KV-cache size, so models could answer faster and handle longer contexts more cheaply. Users feel this as lower latency and more affordable long-context models. citeturn7search1turn4search2turn9search2 | Fast Transformer Decoding, GQA, Mistral 7B. citeturn7search1turn4search2turn9search2 |
| **FlashAttention** | Brought major wall-clock and memory improvements to training and inference, especially for long sequences. This helped turn “long context” from a demo into a product feature. citeturn4search1turn4search5 | FlashAttention family. citeturn4search1turn4search5 |
| **Mixture-of-Experts** | Allowed larger total parameter counts without paying dense compute cost on every token, improving the quality/cost frontier. Users feel this as stronger yet cheaper models. citeturn4search3turn9search3turn18search2 | Switch Transformers, Mixtral, DeepSeek V2/V3. citeturn4search3turn9search3turn18search2turn18search1 |
| **BF16 and later FP8** | Lower-precision math dramatically reduced training cost while preserving quality, enabling faster release cycles and larger practical models. citeturn5search0turn19search0turn19search2 | BF16 training studies and FP8 papers. citeturn5search0turn19search0turn19search2 |
| **Quantization** | Enabled local inference, cheaper deployment, and open-weight experimentation. This is why hobbyists and startups could run capable models on modest hardware. citeturn6search0turn6search1turn5search1turn30view1 | LLM.int8, GPTQ, QLoRA, and the later GGUF/llama.cpp quantization ecosystem. citeturn6search0turn6search1turn5search1turn30view1 |
| **LoRA and PEFT** | Made task adaptation cheap enough that people could customize models instead of always training from scratch. citeturn6search2turn5search1 | LoRA, QLoRA. citeturn6search2turn5search1 |
| **Speculative decoding** | Reduced latency by drafting multiple tokens and verifying them with a stronger model. Users feel this mostly as “faster models.” citeturn7search2 | DeepMind’s speculative sampling paper. citeturn7search2 |
| **Sliding-window and hybrid attention** | Kept long-context computation manageable by mixing local and broader attention patterns. citeturn9search2 | Mistral 7B’s sliding-window attention is a practical landmark. citeturn9search2 |
| **Selective state-space models such as Mamba** | Offered an alternative to pure attention for long sequences and high-throughput inference. Still not the dominant general recipe, but important in the “post-transformer” search space. citeturn5search2 | Mamba. citeturn5search2 |
| **Multi-head latent attention and KV-cache compression** | Directly targeted the cost of long-context inference by making the cache smaller. Users feel this as cheaper, longer-running agents and faster local/server inference. citeturn18search2turn18search1turn29search11 | DeepSeek V2/V3, TurboQuant research. citeturn18search2turn18search1turn29search11 |
| **Structured outputs and constrained decoding** | Turned fragile free-text prompting into dependable machine interfaces. This is one of the quiet enablers of serious agent workflows. citeturn25view3turn26view0 | OpenAI Structured Outputs and Anthropic strict tool use. citeturn25view3turn26view0 |
| **Prompt caching and context caching** | Lowered cost and latency for repeated long instructions, which matters enormously in production agent systems with large common prefixes. citeturn14search5turn14search7 | OpenAI prompt caching, Google context caching in Gemini 1.5. citeturn14search5turn14search7 |
| **Native multimodality** | Changed AI from “text box” to “assistant that can see, hear, speak, and act,” which is essential for browser use, computer use, and coding from screenshots or UI context. citeturn28view2turn28view4turn14search2 | GPT-4o, Gemini 2.0, Anthropic computer use. citeturn28view2turn28view4turn14search2 |

The important causal point is this: **usage innovations usually arrived when architecture and inference created enough slack**. When context got longer, people shifted from pure prompting to RAG and then to context engineering. When tool calls became reliable and schema-constrained, people built agents instead of regex-parsing chat text. When quantization and open weights matured, local and CLI tools exploded. When coding ability and shell interfaces improved, spec-driven and agentic coding became practical. And once those usage patterns became important, labs started optimizing models specifically for long context, tool use, code, latency, and agent benchmarks. citeturn28view0turn24view1turn25view2turn25view3turn30view1turn25view0turn24view3turn28view4

## The concept map from your list to the literature

Some of your themes have a canonical paper. Others are chiefly **engineering doctrines** that were later named and popularized. For those, the right thing is to identify the **closest academic anchor**, not pretend there is one universally accepted paper.

| Theme | Canonical paper or closest academic anchor | Practical/popular gateway |
| --- | --- | --- |
| **Prompt engineering** | Closest anchor: GPT-3/few-shot prompting and later CoT papers. There is no single canonical “prompt engineering paper.” citeturn34search1turn36search7 | OpenAI prompt-engineering guide; Anthropic prompting docs; DAIR.AI Prompting Guide. citeturn11search1turn10search3turn23search0 |
| **System and user prompts** | Closest anchor: InstructGPT and Constitutional AI. In production, this crystallized more in docs/specs than in one paper. citeturn34search0turn36search2 | OpenAI Model Spec and text-generation docs; Anthropic system prompts page. citeturn24view0turn13search2turn26view1 |
| **RAG** | Canonical paper: Lewis et al., 2020. citeturn36search0 | Pinecone’s RAG series remains a strong practitioner gateway. citeturn23search1turn23search4 |
| **Context engineering** | No single canonical research paper; closest lineage is RAG + long memory + agent loops. The term itself was explicitly articulated by Anthropic in 2025. citeturn36search0turn34search3turn24view1 | Anthropic’s “Effective context engineering for AI agents.” citeturn24view1 |
| **Tool use / function calling** | Canonical paper: Toolformer. Practical ecosystem anchor: ReAct. citeturn34search2turn35search0 | OpenAI function calling; Anthropic tool use docs. citeturn25view2turn26view0 |
| **Agentic harnesses** | Canonical paper: ReAct. Industrial distillation: Anthropic’s workflow/agent taxonomy. citeturn35search0turn24view2 | Lilian Weng on autonomous agents; Anthropic’s “Building effective agents.” citeturn27view0turn24view2 |
| **Autonomous agents** | Canonical papers: ReAct, Generative Agents, Reflexion. citeturn35search0turn35search2turn35search1 | Lilian Weng’s essay was arguably the clearest lay bridge for this whole cluster. citeturn27view0 |
| **CLI coding tools** | Closest academic anchor: SWE-agent and SWE-bench. These systems depend as much on interfaces/tooling as on the underlying model. citeturn1search11turn31search0 | Simon Willison’s “How coding agents work,” plus Codex CLI, Gemini CLI, and Aider docs. citeturn27view2turn25view0turn24view3turn26view3 |
| **Wiki-based memory** | No single canonical paper for the recent “LLM wiki” pattern. Closest anchors are Generative Agents, MemoryBank, and MemGPT. citeturn35search2turn17search3turn34search3 | Karpathy’s LLM-wiki post/gist and follow-on explainers. citeturn32search1turn32search0turn32search11 |
| **Spec-driven design** | No canonical arXiv paper yet. Closest academic neighbor is SWE-agent; the concept is mostly an engineering doctrine as of 2025–2026. citeturn1search11 | GitHub Spec Kit, Microsoft’s SDD essays, and Martin Fowler’s analysis. citeturn33view0turn33view1turn33view2 |
| **Prompt injection and agent security** | Canonical papers: indirect prompt injection and prompt injection attacks on LLM-integrated apps. citeturn15search1turn15search0turn15search2 | Simon Willison’s prompt-injection essays did a huge amount of public sense-making. citeturn27view3turn11search7 |
| **MCP and tool ecosystems** | No foundational arXiv paper yet in the same sense as RAG or ReAct; this is a standards-layer development. citeturn26view2turn16search1 | Anthropic’s MCP announcement and the MCP docs are the real entry points. citeturn26view2turn16search1 |
| **Evaluation harnesses** | Canonical anchors: SWE-bench, GAIA, WebArena, MT-Bench/LLM-as-judge. These changed what labs optimize for. citeturn31search0turn31search1turn31search2turn31search3 | Benchmarks tend to spread via papers first, then blog posts and model cards. For coding agents, vendor docs now routinely cite SWE-bench. citeturn26view0turn28view3 |

If you want the shortest possible thesis for this entire table, it is this: **the field moved from “better models” to “better interfaces for using models” to “better systems around models.”** citeturn34search1turn34search0turn36search0turn35search0turn24view2

## A reading path for a fast learner who wants depth

A strong reading order is not “oldest to newest”; it is **conceptual scaffolding first, then operational depth**.

Start with the foundational usage shift:

Read **GPT-3 / few-shot learning** first, then OpenAI’s original API framing. That gives you the mental jump from “train for a task” to “describe the task in text.” citeturn34search1turn22search0

Then read **InstructGPT** and **Constitutional AI**. Those explain why chat assistants differ from raw base models, and why model behavior is partly a product of tuning, policies, and instruction hierarchy. citeturn34search0turn36search2turn24view0

Next read **Chain-of-Thought** and **Self-Consistency**. That gives you the key realization that inference strategy and prompt structure are part of capability. citeturn36search7turn36search1

Then read **RAG**. This is the core paper for “use the model with external knowledge.” It is the cleanest bridge from pure prompting to production systems. citeturn36search0

After that, move to **ReAct** and **Toolformer**. Those are the doorway to agents and tool use. Once you understand those two, most modern agent frameworks will feel like variations on a known theme. citeturn35search0turn34search2

Then read **Generative Agents**, **Reflexion**, and **MemGPT**. That cluster will teach you how researchers think about planning, episodic memory, reflection, and long-horizon continuity. citeturn35search2turn35search1turn34search3

Finally, for software engineering specifically, read **SWE-agent** and **SWE-bench**, then pair them with the modern practitioner literature on coding agents and spec-driven development. That is where the frontier of day-to-day AI use currently lives. citeturn1search11turn31search0turn27view2turn33view0turn33view2

If you prefer a single sentence summary of the “story of AI,” it is this:

**Transformers made giant general models possible; GPT-3 made them usable through prompts; instruction tuning made them conversational; CoT and RAG made them more capable and grounded; ReAct and tool use made them act; memory and context engineering made them persist; coding harnesses and specs made them useful collaborators instead of just eloquent text generators.** citeturn4search0turn34search1turn34search0turn36search7turn36search0turn35search0turn34search3turn24view1turn25view0

## Open questions and limitations

A few items in your request do **not** yet have a single settled canonical paper.

**System prompts**, **context engineering**, **wiki-based memory**, **MCP**, and **spec-driven development** are partly research topics, but they are also heavily shaped by platform docs, engineering blogs, and open-source practice. In those areas, it is more accurate to give a **closest academic anchor plus a practical gateway** than to pretend the literature has already converged. citeturn24view1turn26view2turn33view2

Similarly, terms such as **IQ quants** and sometimes **TurboQuant** live at the boundary between research and implementation ecosystems. IQ quant formats are closely tied to the llama.cpp/GGUF world rather than a single classic paper, while TurboQuant is a newer research result specifically about vector and KV-cache compression rather than a universally adopted industry standard already on the level of GPTQ or QLoRA. citeturn30view1turn29search11

The biggest unresolved intellectual question in the field is probably this: **will future progress come mainly from better base models, or from better scaffolding around them?** The most defensible answer today is “both, in a tight feedback loop.” Labs are clearly still improving models, but real-world capability increasingly depends on retrieval, tool schemas, memory layers, structured outputs, evals, and harness design. citeturn28view0turn25view3turn26view0turn24view2turn31search0turn31search1