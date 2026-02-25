# Daily Brief Skill

A multi-agent orchestration skill for Claude Code that generates daily team intelligence briefs by cross-referencing GitHub, Linear, Slack, PostHog, meeting notes, and braindumps.

## What It Does

Every morning, run `/daily-brief` and get a comprehensive team intelligence report that:

1. **Collects data** from 6 sources simultaneously (parallel agents)
2. **Cross-references** everything using 23 synthesis patterns
3. **Writes back to Linear** — links PRs, syncs statuses, posts initiative updates
4. **Publishes to HackMD** for team-shareable link
5. **Posts highlights to Slack** (with your preview and approval first)

## How It Works

### Phase 1: Setup (~10s)
- Determines date range (yesterday for daily, Fri-Sun for Monday "Week Start Brief")
- Checks which integrations are available
- Scans for meeting notes and braindumps

### Phase 2: Parallel Data Collection (~60-90s)
Spawns 6 agents simultaneously:

| Agent | Source | What It Collects |
|---|---|---|
| `github-analyst` | GitHub CLI | Merged/open/stale PRs, commits, review comments, velocity |
| `slack-monitor` | Slack MCP | Decisions, action items, blockers, unresolved discussions |
| `meeting-reviewer` | Local files | Meeting decisions, action items, priorities, commitments |
| `linear-tracker` | Linear MCP | Issues, cycles, initiatives, milestones, blocked items |
| `braindump-reviewer` | Local files | Strategic thinking, product direction, concerns |
| `posthog-analyst` | PostHog MCP | Visitors, sign-ups, executions, errors, feature adoption |

### Phase 3: Cross-Reference Synthesis (~45s)
The orchestrator connects the dots across all sources:

- **Linear <-> GitHub**: PRs linked to issues? Status mismatches? Untracked work?
- **Slack <-> GitHub <-> Linear**: Discussion topics matched to PRs and issues
- **Meetings <-> GitHub <-> Linear**: Action items with follow-through tracking
- **Braindumps <-> Current Work**: Strategic thinking connected to execution
- **PostHog <-> GitHub**: Feature releases correlated with metric changes
- **Cycles & Initiatives**: Health computed from real data, not self-reported status

### Phase 3.5: Linear Sync-Back (~30-45s)
Writes intelligence BACK to Linear:

- Links PRs to Linear issues via attachments
- Auto-transitions issue status (merged PR → mark Done)
- Posts initiative status updates with health assessment
- Flags overdue milestones

### Phase 3.7: HackMD Publish (~10s)
Creates a private HackMD note with the full brief for team sharing.

### Phase 4: Slack Post (~10s)
Shows you a preview of the highlight message, then posts to your team channel after you confirm.

## Cross-Reference Patterns

The skill uses 23 cross-reference patterns. Here are the most impactful:

| # | Pattern | What It Catches |
|---|---|---|
| 1 | Linear issue + PR | Links them in Linear, flags status mismatches |
| 2 | Linear "In Progress" + no PR | Work claimed but no code started |
| 6 | Meeting action item + no PR/Linear | Commitments with no follow-through |
| 8 | Slack agreement + contradicting activity | Misalignment between words and actions |
| 13 | PR merged + Linear still open | Auto-syncs to "Done" |
| 18 | Merged PR + PostHog metric spike | Correlates releases to impact |
| 19 | Merged PR + PostHog error spike | Potential regression detection |
| 22 | Funnel drop-off + no Linear issue | Untracked product gaps |

## Output Structure

The brief follows a priority-ordered structure:

1. **Opening** — Quick vibe check (good day? quiet? problems?)
2. **Heads Up** — Top 3-5 alerts needing attention today
3. **Key Insights** — Synthesized cross-referenced findings
4. **What Shipped** — Merged PRs, grouped by theme
5. **What's In Progress** — Open PRs with review status + Linear alignment
6. **Initiative Health Dashboard** — Each initiative with computed health
7. **Cycle & Sprint Health** — % complete, pace, scope changes
8. **Team Snapshot** — Velocity numbers
9. **Product Metrics** — PostHog data with trends and correlations
10. **Linear Sync Report** — What was updated in Linear
11. **Strategic Context** — Braindump insights connected to current work
12. **Discussions** — Detailed Slack summaries (appendix)
13. **Meeting Follow-Up Tracker** — Action items with status indicators

## Installation

```bash
# Project-level
cp daily-brief.md .claude/commands/daily-brief.md

# Or global
cp daily-brief.md ~/.claude/commands/daily-brief.md
```

Then customize the `[CUSTOMIZE]` markers. See [CUSTOMIZATION.md](../../CUSTOMIZATION.md).

## Requirements

| Tool | Required | Used For |
|---|---|---|
| `gh` CLI | Yes | GitHub data collection |
| Linear MCP | Recommended | Issue tracking, sync-back |
| Slack MCP | Optional | Team discussions |
| PostHog MCP | Optional | Product analytics |

## Tips

- **Monday briefs** automatically cover Fri-Sun with adjusted language
- **Missing integrations** are handled gracefully — the skill skips and notes what's unavailable
- **Linear sync-back** is the key differentiator — it makes this a two-way tool, not just a reader
- **Slack posting** always requires your confirmation first — you preview and approve before anything goes out
- **The voice matters** — the brief is written like a teammate talking, not a dashboard reporting. This makes people actually read it.
