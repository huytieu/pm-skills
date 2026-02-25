# Braindump Skill

Quick-capture skill for stream-of-consciousness thoughts with automatic domain classification, theme extraction, and action item identification.

## What It Does

```
You speak or type raw thoughts
        │
        ▼
┌─────────────────────────────┐
│  /braindump                 │
│                             │
│  1. Rapid Capture           │ ← No judgment, preserve voice
│  2. Content Type Detection  │ ← Meeting? → redirect to /meeting-transcript
│  3. Domain Classification   │ ← Personal / Professional / Project / Mixed
│  4. Theme Extraction        │ ← Parallel: context-enricher agent
│  5. Action Item Detection   │
│  6. Competitive Intel Check │ ← Optional: auto-update competitor files
│  7. Save + Tag              │
└─────────────────────────────┘
        │
        ▼
  Structured braindump with metadata,
  themes, action items, and connections
```

## Why It Matters for the Daily Brief

Braindumps feed directly into the daily brief's **Strategic Context** section (Section 11). When you capture a braindump about product direction, competitive concerns, or strategic thinking, the daily brief's `braindump-reviewer` agent picks it up the next morning and:

1. Extracts strategic insights
2. Cross-references with current GitHub/Linear work
3. Flags gaps where thinking exists but no tracked work does

This creates a closed loop: **think → capture → surface in brief → track in Linear → ship**.

## Processing Levels

| Level | Command | What Happens |
|---|---|---|
| 1. Capture | `/braindump` | Quick structure, domain classify, tag |
| 2. Analysis | `/brain-dump-analysis` | Deep thematic analysis, strategic insights |
| 3. Integration | Knowledge consolidation | Pattern recognition across braindumps |

## Installation

```bash
cp braindump.md ~/.claude/commands/braindump.md
```

Customize the `[CUSTOMIZE]` paths for your vault structure.

## Output

Each braindump produces a markdown file with:
- YAML frontmatter (type, domain, energy level, emotional tone, themes, urgency)
- Raw thoughts (preserved as-is)
- Quick structure (themes, action items, questions, connections)
- Processing notes (domain reasoning, next steps)
