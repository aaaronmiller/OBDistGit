# Executive Summary

As of April 2026, the AI coding API market is characterized by a stark strategic divergence between US and Chinese providers, with aggregators playing a key role in bridging the gap. US providers, including OpenAI, Anthropic, and Google, command the premium end of the market. They offer tiered model families (e.g., GPT-5.4/4.1, Claude Opus/Sonnet/Haiku) with flagship models priced significantly higher, such as Anthropic's Claude Opus 4.6 at $5.00/$25.00 per million input/output tokens. Their strategy focuses on differentiating through cutting-edge performance and large context windows, which are now standardizing at 1 million tokens. In sharp contrast, Chinese providers like Zhipu, DeepSeek, and Alibaba are driving an intense price war. Their offerings, such as Zhipu's GLM-4.5 at $0.11/$0.28 per million tokens and DeepSeek's V3 at just $0.01 per million input tokens, are orders of magnitude cheaper. This aggressive pricing, coupled with very low-cost monthly plans (e.g., Zhipu's 20 yuan/month plan), indicates a strategy centered on rapid market share acquisition over immediate profitability. Aggregators like OpenRouter thrive in this fragmented landscape by providing a unified API to access a wide array of models from both regions, offering developers flexibility and convenience without provider lock-in.

# Comparative Overview Table

| Provider (Region) | Flagship Model | Price/1M Tokens (Input/Output) | Standard Monthly Subscription |
| :--- | :--- | :--- | :--- |
| **US Providers** | | | |
| OpenAI | GPT-5.4 | $2.50 / $15.00 | Pay-as-you-go |
| Anthropic | Claude Opus 4.6 | $5.00 / $25.00 | $20/month (Pro Plan) |
| Google | Gemini 3.1 Pro | $2.00 / $12.00 | Pay-as-you-go (from $250/mo tier) |
| Perplexity | Pro Access | ~$5 per 1,000 requests | $20/month |
| **Chinese Providers** | | | |
| Zhipu/GLM | GLM-5 | $0.72 / (Output N/A) | 20 yuan/month (~$2.75 USD) |
| Alibaba/Qwen | Qwen3-Max | $1.60 / (Output N/A) | Pay-as-you-go |
| ByteDance/Doubao | Seed 2.0 Pro | ~$0.47 / (Output N/A) | Pay-as-you-go |
| DeepSeek | DeepSeek V3.2 | $0.28 / $0.42 | Pay-as-you-go |
| **Aggregators** | | | |
| OpenRouter | N/A (Aggregator) | Varies by model | Pay-as-you-go (Free tier available) |

# Us Provider Offerings

## Provider

OpenAI

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Tiered rate limits. For example, the moderation endpoint has a limit of 20,000 tokens per minute at Tier 2.

## Model Name

GPT-5.4

## Model Category

premium

## Input Price Per Million Tokens

2.5

## Output Price Per Million Tokens

15.0

## Context Window

1M tokens

## Cli Access

Accessible via the OpenAI API, which can be used with various CLI tools.

## Agent Compatibility

No specific information found regarding direct compatibility.

## Provider

OpenAI

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Tiered rate limits. For example, the moderation endpoint has a limit of 20,000 tokens per minute at Tier 2.

## Model Name

GPT-4.1

## Model Category

base

## Input Price Per Million Tokens

2.0

## Output Price Per Million Tokens

8.0

## Context Window

256k tokens (128k input and 128k output)

## Cli Access

Accessible via the OpenAI API, which can be used with various CLI tools.

## Agent Compatibility

No specific information found regarding direct compatibility.

## Provider

OpenAI

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Tiered rate limits. For example, the moderation endpoint has a limit of 20,000 tokens per minute at Tier 2.

## Model Name

o3

## Model Category

base

## Input Price Per Million Tokens

2.0

## Output Price Per Million Tokens

8.0

## Context Window

Not specified

## Cli Access

Accessible via the OpenAI API, which can be used with various CLI tools.

## Agent Compatibility

No specific information found regarding direct compatibility.

## Provider

Anthropic/Claude

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based. Pro ($20/month) and Max (starting at $100/month) plans are also available, primarily for web usage.

## Token Limits

Users have reported high token usage and early quota exhaustion with Claude Code.

## Model Name

Claude Opus 4.6

## Model Category

premium

## Input Price Per Million Tokens

5.0

## Output Price Per Million Tokens

25.0

## Context Window

1-million-token

## Cli Access

Accessible via the Anthropic API.

## Agent Compatibility

No specific information found.

## Provider

Anthropic/Claude

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based. Pro ($20/month) and Max (starting at $100/month) plans are also available, primarily for web usage.

## Token Limits

Users have reported high token usage and early quota exhaustion with Claude Code.

## Model Name

Claude Sonnet 4.6

## Model Category

base

## Input Price Per Million Tokens

3.0

## Output Price Per Million Tokens

15.0

## Context Window

1-million-token

## Cli Access

Accessible via the Anthropic API.

## Agent Compatibility

No specific information found.

## Provider

Anthropic/Claude

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based. Pro ($20/month) and Max (starting at $100/month) plans are also available, primarily for web usage.

## Token Limits

Users have reported high token usage and early quota exhaustion with Claude Code.

## Model Name

Claude Haiku 4.5

## Model Category

lite/flash

## Input Price Per Million Tokens

1.0

## Output Price Per Million Tokens

5.0

## Context Window

Not specified

## Cli Access

Accessible via the Anthropic API.

## Agent Compatibility

No specific information found.

## Provider

Google/Gemini

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based, with mandatory billing tier spend caps starting from $250/month.

## Token Limits

Not specified

## Model Name

Gemini 3.1 Pro

## Model Category

premium

## Input Price Per Million Tokens

2.0

## Output Price Per Million Tokens

12.0

## Context Window

200K token

## Cli Access

Accessible via the Gemini API.

## Agent Compatibility

No specific information found.

## Provider

Google/Gemini

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based, with mandatory billing tier spend caps starting from $250/month.

## Token Limits

Not specified

## Model Name

Gemini 3 Flash Preview

## Model Category

lite/flash

## Input Price Per Million Tokens

0.5

## Output Price Per Million Tokens

3.0

## Context Window

1M tokens

## Cli Access

Accessible via the Gemini API.

## Agent Compatibility

No specific information found.

## Provider

Google/Gemini

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based, with mandatory billing tier spend caps starting from $250/month.

## Token Limits

Not specified

## Model Name

Gemini 2.5 Flash

## Model Category

lite/flash

## Input Price Per Million Tokens

0.3

## Output Price Per Million Tokens

0.3

## Context Window

Not specified

## Cli Access

Accessible via the Gemini API.

## Agent Compatibility

No specific information found.

## Provider

Google/Gemini

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based, with mandatory billing tier spend caps starting from $250/month.

## Token Limits

Not specified

## Model Name

Gemini 2.0 Flash-Lite

## Model Category

lite/flash

## Input Price Per Million Tokens

0.075

## Output Price Per Million Tokens

0.3

## Context Window

Not specified

## Cli Access

Accessible via the Gemini API.

## Agent Compatibility

No specific information found.

## Provider

Perplexity

## Subscription Tier

Pro

## Monthly Cost Usd

20.0

## Monthly Token Allocation

$5/month in API credits. Pricing is usage-based at approximately $5 per 1,000 requests.

## Token Limits

Not specified in detail, pricing is per request rather than per token.

## Model Name

Latest AI models

## Model Category

premium

## Input Price Per Million Tokens

0.0

## Output Price Per Million Tokens

0.0

## Context Window

Not specified

## Cli Access

Accessible via the Perplexity API.

## Agent Compatibility

No specific information found.


# Chinese Provider Offerings

## Provider

Qwen

## Parent Company

Alibaba

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Pricing is higher for requests involving over 128k input tokens. Specific TPM/RPM limits were not provided.

## Model Name

Qwen3-Max

## Model Category

premium

## Input Price Per Million Tokens

1.6

## Output Price Per Million Tokens

0.0

## Context Window

Over 128k

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

MiniMax

## Parent Company

MiniMax

## Subscription Tier

Free Tier

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Not specified

## Token Limits

Not specified in the provided information.

## Model Name

M2.7

## Model Category

base

## Input Price Per Million Tokens

0.0

## Output Price Per Million Tokens

0.0

## Context Window

204,800 tokens

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

MiniMax

## Parent Company

MiniMax

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Maximum output of 131,072 tokens. Specific TPM/RPM limits were not provided.

## Model Name

M2.7

## Model Category

base

## Input Price Per Million Tokens

0.3

## Output Price Per Million Tokens

1.2

## Context Window

204,800 tokens

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Zhipu/GLM

## Parent Company

Zhipu

## Subscription Tier

Monthly Plan

## Monthly Cost Usd

2.86

## Monthly Token Allocation

Not specified

## Token Limits

Not specified in the provided information.

## Model Name

GLM-5

## Model Category

premium

## Input Price Per Million Tokens

0.72

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Zhipu/GLM

## Parent Company

Zhipu

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

GLM-4.5

## Model Category

base

## Input Price Per Million Tokens

0.11

## Output Price Per Million Tokens

0.28

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Zhipu/GLM

## Parent Company

Zhipu

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

GLM-4.5-Flash

## Model Category

lite/flash

## Input Price Per Million Tokens

0.0

## Output Price Per Million Tokens

0.0

## Context Window

128K

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Kimi

## Parent Company

Moonshot

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

Kimi K2.5

## Model Category

premium

## Input Price Per Million Tokens

0.153

## Output Price Per Million Tokens

3.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Kimi

## Parent Company

Moonshot

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

Kimi K2

## Model Category

base

## Input Price Per Million Tokens

0.6

## Output Price Per Million Tokens

2.5

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

DeepSeek

## Parent Company

DeepSeek

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

DeepSeek V3.2

## Model Category

premium

## Input Price Per Million Tokens

0.28

## Output Price Per Million Tokens

0.42

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

DeepSeek

## Parent Company

DeepSeek

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

DeepSeek V3

## Model Category

base

## Input Price Per Million Tokens

0.01

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Mimo

## Parent Company

Xiaomi

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

MiMo-V2-Pro

## Model Category

premium

## Input Price Per Million Tokens

1.0

## Output Price Per Million Tokens

3.0

## Context Window

1M tokens

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Mimo

## Parent Company

Xiaomi

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

MiMo V2 Flash

## Model Category

lite/flash

## Input Price Per Million Tokens

0.09

## Output Price Per Million Tokens

0.29

## Context Window

262K tokens

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Ernie

## Parent Company

Baidu

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

ERNIE 5.0

## Model Category

premium

## Input Price Per Million Tokens

0.55

## Output Price Per Million Tokens

2.2

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Ernie

## Parent Company

Baidu

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

ERNIE-4.5-300B-A47B

## Model Category

base

## Input Price Per Million Tokens

0.28

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Ernie

## Parent Company

Baidu

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

ERNIE-4.5-21B-A3B

## Model Category

lite/flash

## Input Price Per Million Tokens

0.07

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

Doubao

## Parent Company

ByteDance

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

Seed 2.0 Pro

## Model Category

premium

## Input Price Per Million Tokens

0.47

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

ByteDance's Volcengine has a partnership with OpenClaw.

## Provider

StepFun

## Parent Company

StepFun

## Subscription Tier

Free Tier

## Monthly Cost Usd

0.0

## Monthly Token Allocation

500k tokens

## Token Limits

Not specified in the provided information.

## Model Name

step-1o-turbo-vision

## Model Category

base

## Input Price Per Million Tokens

0.0

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.

## Provider

StepFun

## Parent Company

StepFun

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Monthly Token Allocation

Usage-based

## Token Limits

Not specified in the provided information.

## Model Name

step-1o-turbo-vision

## Model Category

base

## Input Price Per Million Tokens

0.36

## Output Price Per Million Tokens

0.0

## Context Window

Not specified in the provided information.

## Cli Access

Accessible via the provider's API. No specific restrictions on CLI tool usage were mentioned.

## Agent Compatibility

Not specified in the provided information.


# Aggregator Provider Offerings

## Provider

OpenRouter

## Subscription Tier

Free Tier

## Monthly Cost Usd

0.0

## Token Limits

The free tier is subject to a limit of 50 requests per day and 20 requests per minute.

## Pricing Model

The tier is free, but usage is limited. Pricing for usage beyond the free limits follows a pay-as-you-go model on a per-model basis, generally reflecting the original providers' pricing.

## Supported Models Summary

Access to a vast selection of models from a wide variety of providers, including OpenAI, Anthropic, Google, Alibaba, Zhipu, and others.

## Cli Access

OpenRouter can be utilized with command-line interface (CLI) tools, allowing for programmatic access.

## Agent Compatibility

The platform is explicitly stated to be compatible with Hermes agent scaffolds and OpenClaw.

## Provider

OpenRouter

## Subscription Tier

Pay-as-you-go

## Monthly Cost Usd

0.0

## Token Limits

Token limits are not based on a monthly or weekly allocation but are governed by the rate limits of the individual models being accessed and the user's account balance. The specific limits of the free tier (50 requests/day, 20 requests/minute) do not apply.

## Pricing Model

Operates on a per-model, pay-as-you-go basis. The cost for using each model generally reflects the pricing set by the original providers (e.g., OpenAI, Anthropic).

## Supported Models Summary

Provides access to a vast selection of models from numerous providers, including premium, base, and lite versions from OpenAI, Anthropic, Google, Alibaba, Zhipu, and others.

## Cli Access

Full access via command-line interface (CLI) tools is supported, enabling integration into various development workflows.

## Agent Compatibility

The platform is fully compatible with Hermes agent scaffolds and OpenClaw, facilitating the use of these agents through its API.


# Subscription Tier Analysis

A comparative analysis of subscription tiers across AI API providers reveals several common models as of April 2026:

*   **Free Tiers:** Several providers offer a free entry point. Anthropic provides a free tier for its Claude models. MiniMax also has a free tier. StepFun offers a free tier with an allocation of 500,000 tokens. The aggregator OpenRouter provides a free tier limited to 50 requests per day and 20 requests per minute.

*   **Pro Tiers (~$20/month):** This is a popular tier for individual developers and small teams. 
    *   **Anthropic/Claude:** Offers a Pro plan for $20/month.
    *   **Perplexity:** Has a Pro subscription for $20/month (or $200/year), which notably includes $5/month in API credits, with further API usage being pay-as-you-go.
    *   **Zhipu/GLM:** A plan is available for 20 yuan/month (approximately $2.75/month), representing a very low-cost subscription option among the listed providers.

*   **Enterprise/Higher Tiers:** For users with greater needs, providers offer more substantial plans.
    *   **Anthropic/Claude:** Features 'Max' plans that start at $100/month.
    *   **Google/Gemini:** Implements a unique model with mandatory billing tier spend caps, starting from $250/month. This effectively creates a minimum monthly commitment for API access.

*   **Pay-As-You-Go Dominance:** It is important to note that many providers, particularly OpenAI and most of the Chinese companies listed (Alibaba, Moonshot, DeepSeek, etc.), primarily operate on a pay-as-you-go (PAYG) model for their APIs, where costs are directly tied to token usage rather than a monthly subscription fee. OpenAI's pricing, for instance, is entirely based on per-token costs for different models.

# Token Limit Comparison

Providers impose various token and request limits, which differ by model and tier. The most common limit specified is the context window size, with some providers also detailing rate limits.

*   **Context Window Limits:**
    *   **1M+ Tokens:** Several providers offer models with very large context windows. OpenAI's GPT-5.4, Anthropic's Claude Opus 4.6 and Sonnet 4.6, Google's Gemini 3 Flash Preview, and Xiaomi's MiMo-V2-Pro all support a 1-million-token context window.
    *   **Mid-Range (100k-300k Tokens):** This is a common range for many models. OpenAI's ChatGPT has a 256k token window (128k input, 128k output). Google's Gemini 3.1 Pro has a 200k window. MiniMax's M2.7 model supports 204,800 tokens. Xiaomi's MiMo V2 Flash supports up to 262k tokens. Zhipu's GLM-4.5-Flash supports a 128k context.

*   **Rate and Usage Limits:**
    *   **OpenAI:** Implements tiered rate limits. For example, its moderation endpoint has a limit of 20,000 tokens per minute (TPM) at Tier 2.
    *   **OpenRouter:** The free tier is explicitly limited to 50 requests per day and 20 requests per minute.
    *   **Anthropic/Claude:** While specific rate limits are not detailed in the text, it is noted that users have reported high token usage and exhausting their quotas early when using Claude Code, suggesting that usage caps can be a practical concern.
    *   **MiniMax:** The M2.7 model has a maximum output limit of 131,072 tokens per request.

*   **Provider-Specific Details:**
    *   **Alibaba/Qwen:** While not a direct token limit, pricing changes for requests with input exceeding 128k tokens, effectively creating a soft cap or surcharge for larger contexts.

For most other providers, specific TPM, RPM, or monthly/weekly caps are not detailed in the provided text, with the focus being on the maximum context window size of the available models.

# Model Pricing And Availability

AI providers structure their pricing across different model classes to offer a trade-off between capability, speed, and cost. The general classes are lite/flash (for speed and low cost), base/pro (for general use), and premium/opus (for maximum capability).

**US Providers:**
*   **OpenAI:**
    *   Premium: GPT-5.4 ($2.50/1M input, $15.00/1M output)
    *   Base/Pro: GPT-4.1 and o3 (both at $2.00/1M input, $8.00/1M output)
*   **Anthropic/Claude:**
    *   Premium/Opus: Claude Opus 4.6 ($5.00/1M input, $25.00/1M output)
    *   Base/Pro: Claude Sonnet 4.6 ($3.00/1M input, $15.00/1M output)
    *   Lite/Haiku: Claude Haiku 4.5 ($1.00/1M input, $5.00/1M output)
*   **Google/Gemini:**
    *   Premium: Gemini 3.1 Pro ($2.00/1M input, $12.00/1M output)
    *   Lite/Flash: A wide range of cheaper, faster models including Gemini 3 Flash Preview ($0.50/1M input, $3.00/1M output), Gemini 2.5 Flash ($0.30/1M total), and the very inexpensive Gemini 2.0 Flash-Lite ($0.075/1M input, $0.30/1M output).

**Chinese Providers:**
*   **Alibaba/Qwen:** Qwen3-Max is priced at $1.60/1M tokens.
*   **Zhipu/GLM:**
    *   Premium: GLM-5 ($0.72/1M input)
    *   Base/Pro: GLM-4.5 ($0.11/1M input, $0.28/1M output)
*   **Moonshot/Kimi:** Offers Kimi K2.5 ($0.153/1M input, $3.00/1M output) and the more expensive Kimi K2 ($0.60/1M input, $2.50/1M output).
*   **DeepSeek:**
    *   Base/Pro: DeepSeek V3.2 ($0.28/1M input, $0.42/1M output)
    *   Lite: DeepSeek V3 is extremely cheap at $0.01/1M input tokens.
*   **Xiaomi/Mimo:**
    *   Premium: MiMo-V2-Pro ($1.00/1M input, $3.00/1M output)
    *   Lite/Flash: MiMo V2 Flash ($0.09/1M input, $0.29/1M output)
*   **Baidu/Ernie:**
    *   Premium: ERNIE 5.0 (~$0.55/1M input, $2.20/1M output)
    *   Base/Pro: ERNIE-4.5-300B-A47B ($0.28/1M total)
    *   Lite: ERNIE-4.5-21B-A3B ($0.07/1M total)
*   **ByteDance/Doubao:** Seed 2.0 Pro is priced at approximately $0.47/1M input tokens.
*   **StepFun:** Offers models ranging from 2.5 yuan/1M tokens (~$0.34/1M) to 15 yuan/1M tokens (~$2.07/1M).

**Aggregators:**
*   **OpenRouter:** Provides access to a vast selection of the models listed above from various providers, with pricing that generally reflects the source provider's rates.

# Cli And Agent Compatibility Report

As of April 2026, most AI API providers, including US companies like OpenAI, Anthropic, Google, and Perplexity, as well as Chinese providers, offer access through APIs rather than dedicated, proprietary CLI tools. This API-centric approach allows developers to integrate the models into their own custom CLI workflows or use third-party tools.

The aggregator platform OpenRouter provides a unified way to access a vast selection of models from many of these providers via a single API, and it is explicitly noted as being usable with CLI tools. This makes it a versatile option for developers who want to experiment with different models without integrating multiple provider-specific APIs.

Regarding agent framework compatibility, information for individual providers is limited. However, OpenRouter stands out with stated compatibility for both Hermes agent scaffolds and the OpenClaw framework. This allows developers to use models from OpenAI, Anthropic, Google, and others within these agentic structures. Among the individual providers, ByteDance is noted to have a partnership between its Volcengine division and OpenClaw, suggesting direct compatibility or integration. For other major providers like OpenAI, Anthropic, and Google, no specific commercial restrictions or direct compatibility with OpenClaw or Hermes are mentioned in the provided information.

# Current Model Landscape April 2026

As of April 2026, the AI model landscape features a competitive array of flagship, premium, and lite models from major US and Chinese providers, with a significant trend towards 1-million-token context windows in high-end offerings.

**US Providers:**
*   **OpenAI:** The flagship model is **GPT-5.4**, which supports a context window of up to 1 million tokens. Other primary models include **GPT-4.1** (with a 256k token context window) and **o3**.
*   **Anthropic/Claude:** The top-tier model is **Claude Opus 4.6**, featuring a 1-million-token context window. It is followed by the mid-tier **Claude Sonnet 4.6** (also with a 1M token context) and the base model **Claude Haiku 4.5**.
*   **Google/Gemini:** The premium model is **Gemini 3.1 Pro** with a 200K token context window. A preview version, **Gemini 3 Flash Preview**, supports up to 1 million tokens. Lighter, more cost-effective base models include **Gemini 2.5 Flash** and **Gemini 2.0 Flash-Lite**.
*   **Perplexity:** While specific model names are not detailed, its Pro plan provides access to the latest and most capable AI models available on its platform.

**Chinese Providers:**
*   **Alibaba/Qwen:** The flagship model is **Qwen3-Max**.
*   **Zhipu/GLM:** The premium model is **GLM-5**. A lower-cost option, **GLM-4.5-Flash**, supports a 128K context.
*   **MiniMax:** The primary offering is the **M2.7** model, which has a 204,800 token context window.
*   **Xiaomi/Mimo:** The flagship is **MiMo-V2-Pro**, notable for its 1-million-token context window. A lite version, **MiMo V2 Flash**, supports up to 262K tokens.
*   **Moonshot/Kimi:** The main models are **Kimi K2.5** and **Kimi K2**.
*   **Baidu/Ernie:** The top model is **ERNIE 5.0**, with cheaper alternatives like **ERNIE-4.5-300B-A47B** and **ERNIE-4.5-21B-A3B** available.
*   **DeepSeek:** The primary models are **DeepSeek V3.2** and the highly economical **V3**.
*   **ByteDance/Doubao:** The main model offered is **Seed 2.0 Pro**.
*   **StepFun:** A key model available is **step-1o-turbo-vision**.

# Premium Model Surcharges

The analysis of pricing structures indicates that most providers do not apply surcharges in the traditional sense. Instead, they offer different models at distinct price points, with premium models having a higher per-token cost than base or lite models. For US providers like OpenAI, Anthropic, and Perplexity, the provided information explicitly states that premium model surcharges are 'Not applicable' because pricing is on a per-model basis.

The primary exception identified is **Alibaba/Qwen**, which implements a pricing model that functions as a surcharge for using an extended context window. The pricing for its models varies based on the context length, with higher prices applied to requests that utilize over 128,000 input tokens. This is a direct additional cost for leveraging the model's larger context capabilities, differing from the flat per-token rate model used by most other providers.

# Market Trends And Pricing Strategies

As of April 2026, the AI coding API market is defined by several key trends. The most significant is the intense price competition, primarily instigated by Chinese providers. This has resulted in a dramatic reduction in API costs, with some models being offered at near-zero prices. For instance, DeepSeek offers its V3 model for as low as $0.01 per million input tokens, and Zhipu's GLM-4.5 is priced at $0.11/$0.28 per million input/output tokens. These prices are a fraction of those from US counterparts like Anthropic's Claude Opus 4.6 ($5.00/$25.00) and OpenAI's GPT-5.4 ($2.50/$15.00). This pricing strategy suggests Chinese firms are prioritizing market share and user acquisition over short-term revenue.

A second major trend is the increasing standardization of 1-million-plus token context windows. What was once a premium, differentiating feature is now becoming a common offering for high-end models across regions. Providers like OpenAI (GPT-5.4), Anthropic (Claude Opus 4.6), Google (Gemini 3 Flash Preview), and Xiaomi (MiMo-V2-Pro) all offer models with 1M token context windows, enabling more complex and context-aware applications.

Finally, there is a clear divergence in pricing strategies. US providers maintain a tiered approach, offering premium-priced flagship models alongside more affordable 'lite' or 'flash' versions (e.g., Gemini Flash, Claude Haiku) to cater to different segments. Their pricing remains primarily pay-as-you-go based on token usage. In contrast, the Chinese market is not only competing on per-token price but also experimenting with extremely low-cost subscription plans, such as Zhipu's 20 yuan/month offering, to lock in users and encourage adoption.

# Special Offers And Free Tiers

## Provider Name

StepFun

## Offer Type

Free Tier

## Description

StepFun provides a free tier for users, granting an initial allocation of 500,000 tokens to be used with their models, such as `step-1o-turbo-vision`.

## Value

500,000 tokens

## Conditions

The provided information does not specify any conditions, but free tiers are typically available for new users and may come with usage rate limits or an expiration period.


# Pay As You Go Options

Pay-as-you-go (PAYG) is the predominant pricing model for API access across the majority of US, Chinese, and aggregator providers, allowing users to pay directly for their token consumption without a monthly subscription.

*   **US Providers:**
    *   **OpenAI:** Operates primarily on a PAYG model, where all costs are based on the number and type of tokens processed by their various models (e.g., GPT-5.4, GPT-4.1).
    *   **Anthropic/Claude:** While offering Pro and Max subscription plans, it also provides a standard PAYG API pricing structure for its Opus, Sonnet, and Haiku models.
    *   **Google/Gemini:** Uses a PAYG model based on token usage, but with the notable requirement of a mandatory monthly spending cap, starting at $250/month.
    *   **Perplexity:** Offers a usage-based API pricing model at approximately $5 per 1,000 requests. This is available to all users, though Pro subscribers receive a $5 monthly credit towards this usage.

*   **Chinese Providers:**
    *   All listed Chinese providers—**Alibaba/Qwen, MiniMax, Zhipu/GLM, Moonshot/Kimi, DeepSeek, Xiaomi/Mimo, Baidu/Ernie, ByteDance/Doubao, and StepFun**—have their API pricing detailed in per-token costs (e.g., dollars or yuan per million tokens). This indicates that PAYG is the standard model for API access across these services, even if some also offer optional subscription plans (like Zhipu and MiniMax).

*   **Aggregators:**
    *   **OpenRouter:** Functions entirely as a PAYG platform. It provides access to a multitude of models from other providers, and users pay on a per-model, per-token basis that generally aligns with the original provider's pricing.

# Data Sourcing And Inference Notes

The information presented in this report is based on data collected and analyzed as of April 2, 2026. In accordance with the user's request, this analysis incorporates information from a variety of sources. While official pricing pages and API documentation were the primary sources, in cases where such official data was not available or was incomplete, the information regarding token limits, pricing, and model availability has been inferred from secondary sources. These sources include, but are not limited to, public announcements, posts on social media platforms, and technical discussions in developer communities. Therefore, some figures, particularly for newer or less transparently priced models, should be considered well-informed estimates based on the available public data.
