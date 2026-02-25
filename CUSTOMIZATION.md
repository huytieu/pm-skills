# Customization Guide

This guide walks you through adapting the daily brief skill for your team. Every `[CUSTOMIZE]` marker in the skill file indicates a value you should replace.

## Required Configuration

### 1. GitHub Repository

Find and replace all instances of:
```
[CUSTOMIZE: your-org/your-repo]
```

With your actual GitHub repository, e.g., `acme-corp/acme-app`.

### 2. Linear Issue Prefix

Find and replace:
```
[CUSTOMIZE: PROJ]
```

With your Linear issue prefix (e.g., `ACME`, `ENG`, `PROD`). The skill uses this to match PR titles/branches to Linear issues using the pattern `PROJ-123`.

### 3. Slack Channel

Find and replace:
```
[CUSTOMIZE: your-team-channel]
```

With your team's primary Slack channel name (without the `#`).

### 4. Vault Paths

Replace the file paths for meetings and braindumps:

```
[CUSTOMIZE: path/to/meetings/]     → e.g., meetings/
[CUSTOMIZE: path/to/braindumps/]   → e.g., braindumps/
[CUSTOMIZE: path/to/checkins/]     → e.g., daily-checkins/
[CUSTOMIZE: path/to/briefs/]       → e.g., briefs/
```

These are relative paths within your project or Obsidian vault.

### 5. Output Path

The brief gets saved to:
```
[CUSTOMIZE: path/to/briefs/]daily-brief-YYYY-MM-DD.md
```

Change this to wherever you want briefs stored.

## Optional Configuration

### PostHog Analytics

If you use PostHog, update:
```
[CUSTOMIZE: your-posthog-project-id]     → e.g., 12345
[CUSTOMIZE: your-posthog-dashboard-id]   → e.g., 67890
```

If you don't use PostHog, the skill will skip the analytics section automatically.

### HackMD Publishing

If you want to publish briefs to HackMD for team sharing:

1. Get an API token from [HackMD Settings](https://hackmd.io/settings#api)
2. Store it in `.claude/settings/hackmd-token` (one line, no whitespace)
3. Update `[CUSTOMIZE: your-hackmd-username]` with your HackMD username

If you don't configure HackMD, Phase 3.7 is skipped and no link is included in the Slack message.

### Initiative Names

The metadata template includes example initiative names. Replace them with your actual OKRs/initiatives:

```yaml
initiatives:
  - name: "[CUSTOMIZE: Your Initiative 1]"
  - name: "[CUSTOMIZE: Your Initiative 2]"
```

## Adjusting Voice & Tone

The skill is opinionated by default — it writes like a teammate, not a dashboard. If you prefer a different tone:

- **More formal**: Edit the "Voice & Tone" section to remove the casual language guidelines
- **Less opinionated**: Remove the "Flag risks honestly" and "Be direct" directives
- **Team-specific jargon**: Add your own terminology to the example tone section

## Adding/Removing Sections

The content structure in the skill is modular. Each section is independent. To remove a section:

1. Delete it from the "Content Structure" section
2. Remove any related cross-reference rules from "Synthesis Rules"
3. Remove the corresponding agent from Phase 2 if you're removing an entire data source

To add a section:

1. Add a new agent in Phase 2 for data collection
2. Add cross-reference patterns in Phase 3
3. Add the section to the content structure with its priority position

## Removing Data Sources Entirely

If you don't use one of the integrations:

| Integration | What to remove |
|---|---|
| Linear | Agent 4, Phase 3.5 (sync-back), cross-ref rules 1-3, 7, 12-17 |
| Slack | Agent 2, Phase 4, cross-ref rules 4-5, 8-9 |
| PostHog | Agent 6, cross-ref rules 18-23 |
| Meetings | Agent 3, cross-ref rules 6-7 |
| Braindumps | Agent 5, cross-ref rules 10-11 |

The skill is designed to degrade gracefully — you can run it with just GitHub and still get useful output.

## Changing the Linear Sync-Back Behavior

Phase 3.5 writes data back to Linear. If you want read-only mode:

1. Delete the entire "Phase 3.5" section
2. Remove the "Linear Sync Report" from the content structure
3. Remove the `linear_sync` block from the metadata template

If you want sync-back but with more conservative behavior:

- Change auto-transitions to "recommended" actions (logged but not executed)
- Remove the initiative status update posting
- Keep only PR-to-issue linking (lowest risk operation)
