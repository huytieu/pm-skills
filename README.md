# PM Skills for Claude Code

A product manager's skill collection for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). These are battle-tested orchestration prompts that turn Claude into a proactive team intelligence tool — not just a code assistant.

## Skills Overview

### 1. Daily Brief (`/daily-brief`)

A lightweight, fast daily brief that cross-references **GitHub + Linear + Slack + local notes** to surface what matters. Designed to run in ~3 minutes without overwhelming the agent.

```
┌─────────────────────────────────────────────────────────────────┐
│                     /daily-brief                                │
│                                                                 │
│  Phase 1: Setup                                          ~10s   │
│  ├── Determine date range (yesterday / Fri-Sun if Monday)       │
│  ├── Check available MCP integrations                           │
│  └── Scan for meeting notes & braindumps                        │
│                                                                 │
│  Phase 2: Parallel Data Collection                    ~60-90s   │
│  ├── [Agent 1] github-analyst ──── PRs, commits, reviews        │
│  ├── [Agent 2] slack-monitor ───── discussions, decisions        │
│  ├── [Agent 3] meeting-reviewer ── action items, priorities      │
│  ├── [Agent 4] linear-tracker ──── issues, cycles, initiatives   │
│  ├── [Agent 5] braindump-reviewer  strategic context             │
│  └── [Agent 6] posthog-analyst ─── metrics, errors, funnels     │
│       (all 6 run simultaneously)                                │
│                                                                 │
│  Phase 3: Cross-Reference Synthesis                      ~45s   │
│  └── 23 patterns connecting all data sources                    │
│                                                                 │
│  Phase 3.5: Linear Sync-Back                          ~30-45s   │
│  └── Write intelligence BACK to Linear                          │
│                                                                 │
│  Phase 3.7: HackMD Publish                               ~10s   │
│  └── Create shareable team link                                 │
│                                                                 │
│  Phase 4: Slack Highlights                               ~10s   │
│  └── Post summary to team channel (after your approval)         │
│                                                                 │
│  Total: ~3-4 minutes                                            │
└─────────────────────────────────────────────────────────────────┘
```

**What it does:**

| Input Source | What It Reads | What It Produces |
|---|---|---|
| GitHub | Merged/open/stale PRs, commits, review comments | Velocity snapshot, stale PR alerts, review bottleneck detection |
| Linear | Issues, cycles, initiatives, milestones, projects | Initiative health dashboard, cycle progress, blocked item alerts |
| Slack | Channel messages, threads, decisions | Discussion summaries, action items, unresolved thread flags |
| PostHog | Visitors, sign-ups, feature events, errors | Metric trends, anomaly detection, release-to-impact correlation |
| Meeting Notes | Local markdown files | Action item tracking, commitment follow-up |
| Braindumps | Local markdown files | Strategic context, product direction signals |

**What makes it different from a dashboard:**

The cross-referencing is the magic. It doesn't just pull data — it connects dots:

```
  PR #312 merged ──────────┐
                           ├──→ "Workflow builder shipped AND PostHog shows
  PostHog: core_events ↑34% ┘    23 new users trying it. Good signal."

  Meeting: "Alex will fix onboarding" ──┐
                                        ├──→ "Action item from Thursday —
  Linear: No issue created              │    no Linear issue, no PR.
  GitHub: No PR opened     ─────────────┘    Falling through the cracks."

  Slack: "Users complaining about logout" ──┐
                                            ├──→ "Confirmed: Slack reports
  PostHog: auth_token_expired errors ↑200%  ┘    match PostHog error spike."
```

**And it writes BACK to Linear** — not just read-only:
- Links PRs to Linear issues automatically
- Auto-transitions issue status when PRs merge
- Posts initiative health updates with real data
- Flags overdue milestones

[Full documentation →](skills/daily-brief/README.md) | [Sample output →](skills/daily-brief/examples/sample-output.md)

---

### 2. Braindump (`/braindump`)

Quick-capture skill for stream-of-consciousness thoughts. Accepts raw voice or text input, auto-classifies into domains (personal/professional/project), extracts themes and action items, and saves structured markdown with metadata.

```
Raw thoughts → /braindump → Structured capture with:
                              • Domain classification
                              • Theme extraction
                              • Action items
                              • Emotional context
                              • Connections to existing work
```

**Key feature:** Braindumps feed directly into the daily brief's "Strategic Context" section. Your thinking from yesterday automatically surfaces in this morning's brief, connected to what the team is actually building.

[Full documentation →](skills/braindump/README.md)

---

### 3. Meeting Transcript (`/meeting-transcript`)

Process meeting recordings and notes into structured, actionable summaries. Runs 3 parallel agents to extract decisions, action items, team dynamics, and strategic context — while aggressively filtering noise (side chats, "can you hear me?", incomplete thoughts).

```
┌─────────────────────────────────────────┐
│  /meeting-transcript                    │
│                                         │
│  [Agent 1] content-extractor            │
│  ├── Decisions with rationale           │
│  ├── Action items with owners           │
│  └── Strategic themes                   │
│                                         │
│  [Agent 2] dynamics-analyst             │
│  ├── Participation assessment           │
│  ├── Decision-making quality            │
│  └── Meeting effectiveness score        │
│                                         │
│  [Agent 3] context-enricher             │
│  ├── Project context connections        │
│  └── Competitive intel extraction       │
└─────────────────────────────────────────┘
```

**Key feature:** Meeting action items are automatically tracked by the daily brief. If someone says "I'll fix the onboarding flow" in a meeting, the brief checks the next morning whether a PR or Linear issue exists — and flags it if nothing happened.

[Full documentation →](skills/meeting-transcript/README.md)

---

### 4. Comprehensive Analysis (`/comprehensive-analysis`)

A deep-dive analysis skill for when you need the full picture — weekly reviews, board prep, or strategic planning sessions. This one intentionally pulls **more data** and spends **more time** synthesizing.

```
┌─────────────────────────────────────────────────────────────────┐
│                 /comprehensive-analysis                         │
│                                                                 │
│  Phase 1: Deep Data Collection                       ~3-5 min   │
│  ├── GitHub: Full 7-day history, contributor stats              │
│  ├── Linear: All initiatives, full cycle history                │
│  ├── PostHog: Funnel analysis, cohort comparison,               │
│  │           retention curves, feature adoption matrix           │
│  ├── Slack: All channels, sentiment analysis                    │
│  └── Meetings: Full week of notes                               │
│                                                                 │
│  Phase 2: Deep Synthesis                             ~2-3 min   │
│  ├── Week-over-week trend analysis                              │
│  ├── Initiative trajectory modeling                             │
│  ├── Team capacity assessment                                   │
│  ├── Risk register update                                       │
│  └── Strategic recommendation generation                        │
│                                                                 │
│  Phase 3: Output                                     ~1-2 min   │
│  ├── Executive summary (for leadership)                         │
│  ├── Team report (for engineering)                              │
│  └── Product report (for stakeholders)                          │
│                                                                 │
│  Total: ~8-12 minutes                                           │
└─────────────────────────────────────────────────────────────────┘
```

Use this for weekly reviews, board prep, or when you need a deeper picture than the daily brief provides.

[Full documentation →](skills/comprehensive-analysis/README.md)

---

## Important: MCP Context Window Warnings

> **Some MCP servers return large payloads that can overwhelm Claude's context window.** This is the #1 gotcha when building multi-agent skills.

### The Problem

Each MCP tool call returns data that consumes context. Heavy integrations like PostHog and Jira can return enormous payloads:

```
Context Budget per Agent: ~100k tokens (approximate)

Typical payload sizes:
  GitHub (gh CLI)     ████░░░░░░  ~5-15k tokens   ✅ Usually fine
  Linear MCP          █████░░░░░  ~10-25k tokens   ✅ Usually fine
  Slack MCP           ██████░░░░  ~15-30k tokens   ⚠️ Can be large
  PostHog MCP         ████████░░  ~20-60k tokens   ⚠️ Often very large
  Jira MCP            █████████░  ~30-80k tokens   🔴 Frequently overwhelming
```

### Why This Matters

When an agent's context fills up, it:
1. **Loses earlier data** — the agent forgets what it already collected
2. **Produces shallow analysis** — not enough room left for synthesis
3. **Fails silently** — no error, just a worse brief

### How the Skills Handle This

**Daily Brief (`/daily-brief`)** is designed to be **context-safe**:
- Each data source runs in its own agent (isolated context)
- Agents return **summarized insights**, not raw data dumps
- PostHog queries are scoped to specific metrics, not full dashboard dumps
- The orchestrator receives pre-synthesized results, not raw API payloads

**Comprehensive Analysis (`/comprehensive-analysis`)** intentionally trades speed for depth:
- Uses more aggressive data collection (full funnels, cohorts, retention)
- Accepts longer runtime (~8-12 min vs ~3-4 min)
- Designed for weekly/ad-hoc use, not daily

### Recommendations

| If you use... | Recommendation |
|---|---|
| **GitHub + Linear only** | Use daily brief as-is. Fast, reliable, plenty of insight. |
| **+ Slack** | Add Slack agent. Watch for channels with high message volume — scope to 1-2 key channels. |
| **+ PostHog** | Add PostHog agent with **specific HogQL queries** (as provided in the skill). Don't use generic "get all insights" — it returns too much. |
| **+ Jira (instead of Linear)** | Replace Linear agent with Jira queries. **Use JQL filters aggressively** — never query all issues. Scope to current sprint + recently updated only. |
| **All integrations** | Use the comprehensive analysis skill for deep dives. Keep the daily brief lean with just GitHub + Linear + Slack for speed. |

### Building Your Own Agents

If you're adding new MCP data sources, follow this pattern:

```
DO:  "Get issues updated in the last 24 hours in project X"
DON'T: "Get all issues in the workspace"

DO:  "Run this specific HogQL query for sign-ups yesterday"
DON'T: "Get all insights from the dashboard"

DO:  "Read messages from #team-channel since yesterday"
DON'T: "Search all channels for recent activity"
```

The agents in these skills already follow this pattern — but if you customize them, keep payload size in mind.

---

## The Full Flow

These skills work together as a closed-loop system:

```
  ┌──────────────┐     ┌──────────────────┐     ┌──────────────────────┐
  │  /braindump   │     │ /meeting-transcript│     │  GitHub / Linear /   │
  │              │     │                  │     │  Slack / PostHog     │
  │  Capture raw  │     │  Process meeting  │     │                      │
  │  thoughts     │     │  into decisions + │     │  Your team's daily   │
  │              │     │  action items     │     │  work across tools   │
  └──────┬───────┘     └────────┬─────────┘     └──────────┬───────────┘
         │                      │                           │
         │    Saved as structured markdown                  │
         │    with metadata & action items                  │
         ▼                      ▼                           ▼
  ┌─────────────────────────────────────────────────────────────────────┐
  │                        /daily-brief                                 │
  │                                                                     │
  │  Reads braindumps → "Strategic Context" section                     │
  │  Reads meetings   → "Meeting Follow-Up Tracker" (tracks action      │
  │                      items against actual GitHub/Linear activity)    │
  │  Reads GitHub     → PRs, commits, review status                     │
  │  Reads Linear     → Issues, cycles, initiatives                     │
  │  Reads Slack      → Discussions, decisions                          │
  │  Reads PostHog    → User metrics, error spikes                      │
  │                                                                     │
  │  Cross-references ALL sources → surfaces insights                   │
  │  Writes BACK to Linear → two-way sync                              │
  │  Publishes to HackMD → shareable team link                         │
  │  Posts to Slack → team highlights                                   │
  └─────────────────────────────────────────────────────────────────────┘
         │
         ▼ (weekly/ad-hoc)
  ┌─────────────────────────────────────┐
  │      /comprehensive-analysis        │
  │                                     │
  │  Deep 7-day analysis for weekly     │
  │  reviews, board prep, or strategic  │
  │  planning. Same sources, more depth.│
  └─────────────────────────────────────┘
```

---

## Quick Start

### Option A: Interactive Setup (Recommended)

```bash
git clone https://github.com/huytieu/pm-skills.git
cd pm-skills
./setup.sh
```

The setup script will:
1. Ask where to install (project-level or global)
2. Let you pick which skills to install
3. Walk you through configuration (GitHub repo, issue prefix, Slack channel, etc.)
4. Replace all `[CUSTOMIZE]` placeholders automatically
5. Check prerequisites (gh CLI, Claude Code)
6. Show available MCP integrations

### Option B: Manual Install

Copy skill files into your Claude Code commands directory:

```bash
# All skills
cp skills/daily-brief/daily-brief.md ~/.claude/commands/daily-brief.md
cp skills/braindump/braindump.md ~/.claude/commands/braindump.md
cp skills/meeting-transcript/meeting-transcript.md ~/.claude/commands/meeting-transcript.md
cp skills/comprehensive-analysis/comprehensive-analysis.md ~/.claude/commands/comprehensive-analysis.md
```

Or for a project-specific install (`.claude/commands/` in your project root).

Then find and replace all `[CUSTOMIZE]` markers. See [CUSTOMIZATION.md](CUSTOMIZATION.md).

### 3. Run it

```
/daily-brief              — daily team intelligence brief (~3-4 min)
/braindump                — capture raw thoughts
/meeting-transcript       — process meeting notes
/comprehensive-analysis   — deep weekly analysis (~8-12 min)
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- GitHub CLI (`gh`) authenticated
- **Optional but recommended:** Linear MCP, Slack MCP, PostHog MCP servers configured in Claude Code

The skills degrade gracefully — if a data source is unavailable, they skip that section and note it. You can start with just GitHub and add integrations over time.

## Templates

The `templates/` directory contains Obsidian-compatible templates for the brief output format. These are optional — the skills generate their own structure, but the templates are useful if you want to pre-create files or understand the output schema.

## Customization

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for a detailed guide on adapting the skills to your team, including:

- Swapping data sources (Linear ↔ Jira, PostHog ↔ Amplitude, etc.)
- Adjusting the voice and tone
- Adding/removing sections
- Changing cross-reference rules
- Configuring the Linear sync-back
- Managing MCP payload sizes

## Philosophy

Most daily standups and status reports are performative. They list what happened without explaining why it matters. They exist in one tool while reality is spread across six.

These skills are built on a different premise: **your AI teammate should read everything you don't have time to read, connect dots you'd miss, and keep your tools in sync with reality.**

The daily brief isn't a dashboard — it's a teammate who shows up every morning having read every PR, every Slack thread, every meeting note, and every analytics dashboard. And then tells you what actually matters.

## Contributing

PRs welcome. If you've built PM skills for Claude Code that follow a similar philosophy — opinionated, cross-referencing, two-way sync — open a PR.

## License

MIT
