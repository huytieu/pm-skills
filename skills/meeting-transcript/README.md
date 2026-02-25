# Meeting Transcript Skill

Process meeting recordings and notes into structured, actionable summaries with intelligent content filtering.

## What It Does

```
Raw transcript (voice/text/recording)
        │
        ▼
┌───────────────────────────────────────────┐
│  /meeting-transcript                      │
│                                           │
│  Phase 1: Setup                           │
│  ├── Detect content type                  │
│  ├── Classify domain                      │
│  └── Split into sections                  │
│                                           │
│  Phase 2: Parallel Processing    ~60-90s  │
│  ├── [Agent 1] content-extractor          │
│  │   └── Decisions, action items, themes  │
│  ├── [Agent 2] dynamics-analyst           │
│  │   └── Team dynamics, effectiveness     │
│  └── [Agent 3] context-enricher           │
│      └── Project context, connections     │
│                                           │
│  Phase 3: Assembly                        │
│  ├── Merge all agent outputs              │
│  ├── Apply content filtering              │
│  ├── Generate structured summary          │
│  └── Save with metadata                   │
└───────────────────────────────────────────┘
        │
        ▼
  Structured meeting notes with:
  - Decisions (with rationale)
  - Action items (with owners + deadlines)
  - Strategic themes
  - Team dynamics assessment
  - Unresolved issues
```

## Content Filtering

The skill aggressively filters noise:

| Filtered OUT | Kept IN |
|---|---|
| "Can you hear me?" | Strategic discussions |
| Side chats about weather | Decision points with rationale |
| "Sorry, my mic was muted" | Action items with owners |
| Incomplete/abandoned thoughts | Problem-solving discussions |
| Casual banter | Planning and resource allocation |

## How It Feeds the Daily Brief

Meeting notes are automatically picked up by the daily brief's `meeting-reviewer` agent:

```
/meeting-transcript → saves structured notes
        │
        ▼ (next morning)
/daily-brief
  ├── Phase 2: meeting-reviewer reads the notes
  ├── Phase 3: cross-references action items with GitHub + Linear
  └── Section 13: Meeting Follow-Up Tracker
        └── "Alex said he'd fix onboarding → No PR opened, no Linear issue ❓"
```

This creates **automatic accountability** — commitments from meetings are tracked against actual execution.

## Installation

```bash
cp meeting-transcript.md ~/.claude/commands/meeting-transcript.md
```

Customize the `[CUSTOMIZE]` paths for your vault structure.
