# AI Coding API Subscription Comparison - April 2026

## Executive Summary

**Best value for Chinese models:** z.ai (GLM) at ~$3/month gives you ~120 prompts/5hrs (3x Claude Pro). MiniMax Token Plan from $10/month gives you M2.7 with weekly quotas.

**Best overall value:** DeepSeek V3 at $0.01/1M input tokens (pay-as-you-go) - essentially free for coding.

---

## TIER 1: Budget Plans (~$2-10/month)

| Provider | Plan Name | Price/month | Tokens/Requests | Reset | Base Model | Lite Model |
|----------|-----------|------------|-----------------|-------|------------|------------|
| **z.ai/GLM** | Lite | ~$3 (20¥) | ~120 prompts/5hrs | 5hr | GLM-4.7 | GLM-4.5-Flash |
| **z.ai/GLM** | Pro | ~$6 (45¥) | ~600 prompts/5hrs | 5hr | GLM-4.7 | GLM-4.5-Flash |
| **MiniMax** | Token Plan Std | $10 | Weekly quota | Weekly | M2.7 | M2.7-Flash |
| **DeepSeek** | Pay-as-you-go | $0 | Usage-based | - | V3 ($0.01/1M) | V3 |
| **StepFun** | Free | $0 | 500K tokens | - | step-1o-turbo-vision | - |

### Token equivalence (to Claude Pro):
- z.ai Lite ≈ 3x Claude Pro (120 vs ~40 prompts/5hrs)
- z.ai Pro ≈ 15x Claude Pro (600 vs ~40 prompts/5hrs)
- MiniMax $10 ≈ similar to Claude Pro but weekly reset vs 5hr

---

## TIER 2: Mid-Tier Plans (~$15-30/month)

| Provider | Plan Name | Price/month | Tokens/Requests | Reset | Base Model | Premium Model |
|----------|-----------|------------|-----------------|-------|------------|--------------|
| **z.ai/GLM** | Max | ~$12 (89¥) | ~2400 prompts/5hrs | 5hr | GLM-5 | GLM-4.7 |
| **MiniMax** | Token Plan Pro | $20 | Larger weekly quota | Weekly | M2.7 | M2.7 |
| **Anthropic** | Pro (web) | $20 | $5 API credits | - | Haiku | Sonnet |
| **Perplexity** | Pro | $20 | $5 API credits + 5000 searches | - | Latest | - |
| **OpenRouter** | Free | $0 | 50 req/day, 20 req/min | Daily | Varies | Varies |

### Token equivalence:
- z.ai Max ≈ 60x Claude Pro (2400 vs ~40 prompts/5hrs)
- MiniMax $20 ≈ similar to Claude Max (5x) tier

---

## TIER 3: Premium Plans (~$50-150/month)

| Provider | Plan Name | Price/month | Features | Base Model | Premium Model |
|----------|-----------|------------|----------|------------|---------------|
| **Anthropic** | Max (5x) | $100 | 5x Claude Pro limits | Sonnet | Opus |
| **Anthropic** | Max (20x) | $200 | 20x Claude Pro limits | Sonnet | Opus |
| **MiniMax** | Token Plan Max | $40-50 | Full weekly quota | M2.7 | M2.7 |
| **Google** | Pay-as-you-go | $250/min | Mandatory spend cap | Gemini 2.0 Flash-Lite | Gemini 3.1 Pro |
| **z.ai/GLM** | Enterprise | Custom | Custom quotas | GLM-5 | - |

---

## Pay-As-You-Go Pricing Comparison (per 1M tokens)

| Provider | Model | Input $/1M | Output $/1M | Context | Notes |
|----------|-------|------------|------------|---------|-------|
| **DeepSeek** | V3 | $0.01 | $0.01 | 64K | Cheapest available |
| **DeepSeek** | V3.2 | $0.28 | $0.42 | 64K | Better reasoning |
| **DeepSeek** | R1 | $0.55 | $2.20 | 64K | Reasoning model |
| **Zhipu/GLM** | GLM-4.5 | $0.11 | $0.28 | 128K | Excellent coding |
| **Zhipu/GLM** | GLM-5 | $0.72 | - | - | Premium |
| **MiniMax** | M2.7 | $0.30 | $1.20 | 200K | Best coding Chinese |
| **Qwen** | Qwen3-Max | $1.60 | - | 128K+ | Alibaba flagship |
| **Kimi** | K2.5 | $0.15 | $3.00 | 256K | Moonshot flagship |
| **Kimi** | K2 | $0.60 | $2.50 | 256K | Older |
| **Xiaomi** | MiMo V2 Flash | $0.09 | $0.29 | 262K | Very cheap |
| **Xiaomi** | MiMo-V2-Pro | $1.00 | $3.00 | 1M | Premium |
| **Baidu** | ERNIE 4.5 Lite | $0.07 | - | - | Budget |
| **Baidu** | ERNIE 5.0 | $0.55 | $2.20 | - | Premium |
| **ByteDance** | Seed 2.0 Pro | $0.47 | - | - | Doubao |

### US Providers (for reference):
| Provider | Model | Input $/1M | Output $/1M | Context |
|----------|-------|------------|------------|---------|
| **OpenAI** | GPT-4.1 | $2.00 | $8.00 | 128K |
| **OpenAI** | GPT-5.4 | $2.50 | $15.00 | 1M |
| **Anthropic** | Haiku | $1.00 | $5.00 | 200K |
| **Anthropic** | Sonnet | $3.00 | $15.00 | 1M |
| **Anthropic** | Opus | $5.00 | $25.00 | 1M |
| **Google** | Gemini 2.0 Flash-Lite | $0.075 | $0.30 | - |
| **Google** | Gemini 3.1 Pro | $2.00 | $12.00 | 200K |

---

## CLI & Agent Compatibility

| Provider | CLI Tools Allowed | OpenClaw/Hermes | Commercial Use |
|----------|-------------------|-----------------|----------------|
| **z.ai** | Yes (API) | Yes | Non-commercial personal coding OK |
| **MiniMax** | Yes (API) | Yes | Non-commercial personal coding OK |
| **DeepSeek** | Yes (API) | Yes | Yes (open usage) |
| **Qwen** | Yes (API) | Yes via Alibaba | Check TOS |
| **Kimi** | Yes (API) | Check | Check TOS |
| **OpenRouter** | Yes | Yes (explicitly supported) | Yes, varies by model |
| **Anthropic** | Yes (API) | Yes | Yes, commercial OK |
| **OpenAI** | Yes (API) | Yes | Yes, commercial OK |

**Note:** Most Chinese providers allow OpenClaw/Hermes for personal/non-commercial coding. Commercial use restrictions vary - check individual TOS.

---

## Special Deals (April 2026)

1. **DeepSeek V3** - $0.01/1M input (essentially free)
2. **StepFun** - 500K free tokens
3. **MiniMax** - Token Plan includes all modalities (text, audio, video, music)
4. **z.ai** - Multiple tiers (Lite/Pro/Max) at very low prices

---

## Recommendation for Coding Use

**For best value on a budget:**
1. **z.ai GLM Lite ($3/mo)** - 3x Claude Pro prompts, GLM-4.7 is excellent for coding (73.8% SWE-bench)
2. **MiniMax Token Plan ($10/mo)** - Weekly quotas, M2.7 is great for coding
3. **DeepSeek V3 (pay-as-you-go)** - $0.01/1M - essentially free

**For power users:**
1. **z.ai Max (~$12/mo)** - 60x Claude Pro limits
2. **MiniMax Token Plan Pro ($20/mo)** - larger weekly quotas

**For premium performance:**
- Pay-as-you-go with MiniMax M2.7 ($0.30/1M input) or Qwen3-Max ($1.60/1M)

---

*Data collected April 2, 2026. Prices and plans subject to change. Token limits based on social media/discussions where official docs unavailable.*