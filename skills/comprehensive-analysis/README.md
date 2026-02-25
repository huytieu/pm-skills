# Comprehensive Analysis Skill

A deep-dive analysis skill for weekly reviews, board prep, and strategic planning. Unlike the daily brief (fast, scoped to yesterday), this skill intentionally pulls more data and spends more time synthesizing across a 7-day window.

## When to Use

| Situation | Use Daily Brief | Use Comprehensive Analysis |
|---|---|---|
| Morning standup prep | Yes | |
| Daily team update | Yes | |
| Weekly team review | | Yes |
| Board meeting prep | | Yes |
| Sprint retro data | | Yes |
| Investigating a problem | | Yes |
| Monthly health check | | Yes |

## How It Differs from Daily Brief

| Aspect | Daily Brief | Comprehensive Analysis |
|---|---|---|
| Time window | Yesterday (or Fri-Sun) | Last 7 days |
| Runtime | ~3-4 minutes | ~8-12 minutes |
| GitHub depth | Merged PRs, open PRs, stale detection | + contributor stats, code churn, PR lifecycle, review quality |
| Linear depth | Issues, cycles, initiative health | + trajectory modeling, scope creep quantification, dependency mapping |
| PostHog depth | Key metrics, error check | + funnel analysis, cohort comparison, feature adoption matrix, growth trajectory |
| Slack depth | Key discussions, action items | + sentiment analysis, communication patterns, topic clustering |
| Output | 1 brief | 3 documents (executive summary, team report, product report) |

## Context Window Warning

This skill is intentionally heavier than the daily brief. The PostHog and Linear agents in particular can pull large payloads. Each agent runs in its own context (isolated), but be aware:

- **PostHog funnel + cohort queries** can return 20-60k tokens
- **Linear full initiative + milestone dumps** can return 10-25k tokens
- **Slack 7-day history** on active channels can return 15-30k tokens

The skill handles this by running each data source in its own agent (context isolation) and asking agents to return **summarized insights** rather than raw data. But if you're on a very active project with hundreds of issues or high Slack volume, consider scoping to specific initiatives or channels.

## Installation

```bash
cp comprehensive-analysis.md ~/.claude/commands/comprehensive-analysis.md
```

Then customize the `[CUSTOMIZE]` markers. See [CUSTOMIZATION.md](../../CUSTOMIZATION.md).

## Requirements

Same as the daily brief. GitHub CLI (`gh`) is required; Linear, Slack, and PostHog MCPs are optional.
