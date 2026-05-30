---
name: growth-launch-pack
description: >-
  Use this skill when preparing product positioning, idea viability, competitor research, SEO briefs, CRO reviews, launch plans, landing page strategy, or growth artifacts. Do not use for implementation, technical deployment readiness, or unclear product ideas that still need requirements-griller.
---


# growth-launch-pack

Frameworks for positioning, validating, launching, and growing a product. The marketing/growth layer that the engineering skills don't cover. For use when you're ready to launch, not during build.

## Purpose

Provide reusable frameworks for: idea validation, competitive analysis, positioning, target segments, SEO content strategy, CRO analysis, and launch planning. Not a marketing automation tool — a thinking framework that produces artifacts you can act on.

## When to use this

- Preparing to launch [Project A], [Project B], or a new product
- Writing landing page copy and need positioning clarity
- Evaluating whether an idea is worth building
- Analyzing competitors before entering a market
- Planning content strategy for organic growth
- Reviewing a page/flow for conversion optimization

## When NOT to use this

- Do not use for implementation, technical deployment readiness, or unclear product ideas that still need requirements-griller.

## Frameworks included

### 1. Idea viability scorecard

Score each dimension 1-5. Weak scores mean: reposition, reduce scope, or find a better channel — not "don't build."

| Dimension | What to evaluate | Strong signal (4-5) |
|---|---|---|
| Problem pain | Is it frequent, expensive, or emotionally painful? | Users already pay or hack solutions |
| Target clarity | Can you name the buyer and where to find them? | Specific segment, not "everyone" |
| Urgency | Must it be solved soon? | Delay has visible cost |
| Differentiation | Why this over alternatives? | Clear wedge or 10x workflow gain |
| Distribution | Can you reach buyers? | Known channels, communities, SEO demand |
| Monetization | Will they pay? | Budget exists, value maps to money/time saved |
| Build feasibility | Can you ship MVP with current resources? | Scope fits your stack and time |
| Founder fit | Do you have insight or access advantage? | You know the workflow or audience deeply |

**Use this before building anything new.** If 3+ dimensions score below 3, reconsider or reposition.

### 2. Positioning statement template

```
For [specific audience]
who struggle with [specific pain],
[product] is a [category]
that helps them [specific outcome],
unlike [main alternative],
because [concrete differentiator with proof].
```

Fill this in before writing any landing page copy. If you can't fill it in, you don't know your positioning yet — run `requirements-griller` deep interrogation mode on it first.

### 3. Competitor brief template

For each competitor (direct, adjacent, and status-quo alternatives):

```markdown
# Competitor: [Name]

## Overview
- URL, category, target customer, pricing

## Product
- Core promise, key features, integrations, gaps

## Positioning
- Headline, value prop, emotional angle

## Acquisition
- SEO topics, content strategy, paid/social, partnerships

## Pricing
- Tiers, free plan, expansion path

## Weaknesses
- UX friction, underserved segments, pricing gaps, complaints

## How to win against them
- Wedge, messaging angle, product advantage
```

### 4. Target segment profile

```markdown
# Segment: [Name]

## Who
- Role, company type, maturity, budget authority

## Pain trigger
- What event creates the need?
- Current workaround?
- Cost of inaction?

## Buying context
- Decision process, objections, required proof

## Language
- Phrases they use, search queries, communities

## Best offer
- Promise, CTA, content topics that resonate
```

### 5. SEO content brief

For planning content that ranks:

```markdown
# Content brief: [Working title]

## Goal and audience
- Primary keyword, search intent, funnel stage
- Target segment from profile above

## SERP analysis
- Top 3 results: what they cover, what's missing
- People Also Ask questions

## Required structure
- H1 angle, H2/H3 outline
- Tables, examples, or tools to include
- Internal links to own content
- External citations needed

## E-E-A-T proof
- Experience: first-hand usage, screenshots, case studies
- Expertise: credentials, technical depth
- Trust: sources, timestamps, real data

## CTA
- Primary and secondary call-to-action
```

**Hub-spoke model:** Build one comprehensive pillar page (3-5k words) with 8-12 supporting subtopic pages (1.5-2.5k words each). Every spoke links to the hub. Update quarterly.

### 6. CRO 7-dimension analysis

For any page, form, or flow that needs to convert:

1. **Value proposition clarity** — Can visitors understand what it is and why it matters in 5 seconds?
2. **Headline effectiveness** — Does it communicate core value with specificity?
3. **CTA placement and copy** — Is there one clear action? Does it communicate value (not "Submit")?
4. **Visual hierarchy** — Can a scanner understand the page without reading?
5. **Trust and social proof** — Credibility signals near decision points?
6. **Objection handling** — Likely concerns answered?
7. **Friction reduction** — Unnecessary steps, fields, choices removed?

**Quick wins** are almost always in dimensions 1, 3, and 7.

### 7. Launch checklist

For shipping a product or major feature publicly:

```markdown
## Pre-launch (1-2 weeks before)
- [ ] Positioning statement finalized
- [ ] Landing page live with CTA
- [ ] Analytics instrumented (Vercel Analytics, PostHog, or equivalent)
- [ ] Error monitoring active (Sentry or equivalent)
- [ ] Support email/channel ready
- [ ] 3-5 beta users have tested
- [ ] Social proof collected (even informal quotes)

## Launch day
- [ ] Production deploy verified
- [ ] Share in 3-5 communities where target segment gathers
- [ ] Post on personal channels (Twitter/X, LinkedIn)
- [ ] Email list if exists
- [ ] Monitor error logs for first 4 hours
- [ ] Respond to all feedback within 24 hours

## Post-launch (week 1-2)
- [ ] Collect user feedback
- [ ] Run CRO analysis on landing page
- [ ] Identify top 3 friction points from real usage
- [ ] Plan first update based on feedback, not assumptions
- [ ] Write 1-2 SEO content pieces targeting validated search terms
```

## Output format

Depends on which framework is invoked. Each framework has its own template above. For a full launch preparation, the output is:

```markdown
# Launch prep — [Product]

## Positioning
[Statement]

## Viability score
[Scorecard with scores and notes]

## Competitors
[Briefs for top 3]

## Target segment
[Profile for primary segment]

## Landing page CRO
[7-dimension analysis of current page]

## Content plan
[3-5 SEO content briefs]

## Launch checklist
[Checklist with status]
```

## Hard rules

- Never write marketing copy without a positioning statement first
- Never launch without at least 3 beta users having tested
- Never assume you know the target segment — profile them explicitly
- Never create content without a content brief and keyword target
- Never test CRO changes without a hypothesis (IF/THEN/BECAUSE)
- Never prioritize new content over improving pages ranking in positions 5-15

## Connects to

- `requirements-griller` — use deep interrogation mode for validating the idea before positioning
- `requirements-griller` — for scoping the MVP after validation
- `notion-brain` — for storing competitive research and positioning docs
- `ui-copy` — for writing the actual interface copy after positioning is clear
- `deploy-ready` — for the technical side of launch readiness

## Common failure modes

**Writing copy before positioning** — Headlines, CTAs, and feature descriptions get drafted before "for X who struggle with Y, this product does Z" is clear. Result: copy that sounds clever but doesn't sell. Positioning first, always.

**Doing competitor research without a target segment** — Listing 10 competitors with feature matrices is theater. Without knowing which segment you're competing for, the analysis is decorative. Start with: "We are competing for [segment] who currently use [alternative]."

**Launch checklist that's generic** — "Set up analytics, write copy, post on social." Every launch needs the same things, but the *content* of those things must be tied to your specific product, audience, and stage. A generic checklist produces a generic launch.

**CRO analysis on a page that doesn't have traffic** — Optimizing conversion before you have anyone to convert is premature. CRO matters when you have ~1000+ monthly visitors. Below that, focus on traffic acquisition (positioning, distribution, content), not page optimization.
