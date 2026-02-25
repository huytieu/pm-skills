#!/bin/bash
# PM Skills Setup Script
# Interactively configures and installs PM skills for Claude Code

set -e

echo "================================================"
echo "  PM Skills for Claude Code — Setup"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect commands directory
if [ -d ".claude/commands" ]; then
    DEFAULT_CMD_DIR=".claude/commands"
    INSTALL_TYPE="project"
elif [ -d "$HOME/.claude/commands" ]; then
    DEFAULT_CMD_DIR="$HOME/.claude/commands"
    INSTALL_TYPE="global"
else
    DEFAULT_CMD_DIR="$HOME/.claude/commands"
    INSTALL_TYPE="global"
fi

echo -e "${BLUE}Step 1: Installation Location${NC}"
echo ""
echo "  1) Project-level  (.claude/commands/)     — skills available in this project only"
echo "  2) Global          (~/.claude/commands/)   — skills available everywhere"
echo ""
read -p "Choose [1/2] (default: 2): " INSTALL_CHOICE

if [ "$INSTALL_CHOICE" = "1" ]; then
    CMD_DIR=".claude/commands"
    echo -e "${GREEN}→ Installing to project: $CMD_DIR${NC}"
else
    CMD_DIR="$HOME/.claude/commands"
    echo -e "${GREEN}→ Installing globally: $CMD_DIR${NC}"
fi

mkdir -p "$CMD_DIR"

echo ""
echo -e "${BLUE}Step 2: Choose Skills to Install${NC}"
echo ""
echo "  1) Daily Brief only              — team intelligence brief (recommended start)"
echo "  2) Daily Brief + Braindump       — + quick thought capture"
echo "  3) Daily Brief + Meeting Notes   — + meeting transcript processing"
echo "  4) All skills                    — daily brief + braindump + meeting + comprehensive analysis"
echo ""
read -p "Choose [1/2/3/4] (default: 4): " SKILL_CHOICE
SKILL_CHOICE=${SKILL_CHOICE:-4}

echo ""
echo -e "${BLUE}Step 3: Configure Your Team${NC}"
echo ""

# GitHub repo
read -p "GitHub repo (e.g., your-org/your-repo): " GITHUB_REPO
if [ -z "$GITHUB_REPO" ]; then
    echo -e "${RED}GitHub repo is required. Exiting.${NC}"
    exit 1
fi

# Issue prefix
read -p "Issue prefix in Linear/Jira (e.g., PROJ, ENG, ACME): " ISSUE_PREFIX
ISSUE_PREFIX=${ISSUE_PREFIX:-PROJ}

# Slack channel
read -p "Team Slack channel (without #, or press Enter to skip): " SLACK_CHANNEL
SLACK_CHANNEL=${SLACK_CHANNEL:-your-team-channel}

# PostHog
read -p "PostHog project ID (or press Enter to skip): " POSTHOG_PROJECT
read -p "PostHog dashboard ID (or press Enter to skip): " POSTHOG_DASHBOARD
read -p "Core value event name in PostHog (e.g., execution_completed, or Enter to skip): " CORE_EVENT

# Vault paths
echo ""
echo -e "${BLUE}Step 4: Configure File Paths${NC}"
echo ""
echo "  These are relative paths where the skills save output."
echo "  Examples: briefs/, meetings/, braindumps/"
echo ""

read -p "Path for daily briefs (default: briefs/): " BRIEFS_PATH
BRIEFS_PATH=${BRIEFS_PATH:-briefs/}

read -p "Path for meeting notes (default: meetings/): " MEETINGS_PATH
MEETINGS_PATH=${MEETINGS_PATH:-meetings/}

read -p "Path for braindumps (default: braindumps/): " BRAINDUMPS_PATH
BRAINDUMPS_PATH=${BRAINDUMPS_PATH:-braindumps/}

read -p "Path for daily checkins (default: checkins/): " CHECKINS_PATH
CHECKINS_PATH=${CHECKINS_PATH:-checkins/}

# HackMD (optional)
echo ""
read -p "HackMD username for publishing (or press Enter to skip): " HACKMD_USER

echo ""
echo -e "${BLUE}Step 5: Installing Skills${NC}"
echo ""

# Function to customize a skill file
customize_and_install() {
    local SOURCE="$1"
    local DEST="$2"
    local FILENAME=$(basename "$DEST")

    if [ ! -f "$SOURCE" ]; then
        echo -e "${RED}  ✗ Source not found: $SOURCE${NC}"
        return 1
    fi

    # Copy and replace placeholders
    cp "$SOURCE" "$DEST"

    # Core replacements
    sed -i.bak "s|\[CUSTOMIZE: your-org/your-repo\]|$GITHUB_REPO|g" "$DEST"
    sed -i.bak "s|\[CUSTOMIZE: PROJ\]|$ISSUE_PREFIX|g" "$DEST"
    sed -i.bak "s|\[CUSTOMIZE: your-team-channel\]|$SLACK_CHANNEL|g" "$DEST"

    # PostHog
    if [ -n "$POSTHOG_PROJECT" ]; then
        sed -i.bak "s|\[CUSTOMIZE: your-posthog-project-id\]|$POSTHOG_PROJECT|g" "$DEST"
    fi
    if [ -n "$POSTHOG_DASHBOARD" ]; then
        sed -i.bak "s|\[CUSTOMIZE: your-posthog-dashboard-id\]|$POSTHOG_DASHBOARD|g" "$DEST"
    fi
    if [ -n "$CORE_EVENT" ]; then
        sed -i.bak "s|\[CUSTOMIZE: your_core_event\]|$CORE_EVENT|g" "$DEST"
    fi

    # Paths
    sed -i.bak "s|\[CUSTOMIZE: path/to/briefs/\]|$BRIEFS_PATH|g" "$DEST"
    sed -i.bak "s|\[CUSTOMIZE: path/to/meetings/\]|$MEETINGS_PATH|g" "$DEST"
    sed -i.bak "s|\[CUSTOMIZE: path/to/braindumps/\]|$BRAINDUMPS_PATH|g" "$DEST"
    sed -i.bak "s|\[CUSTOMIZE: path/to/checkins/\]|$CHECKINS_PATH|g" "$DEST"

    # HackMD
    if [ -n "$HACKMD_USER" ]; then
        sed -i.bak "s|\[CUSTOMIZE: your-hackmd-username\]|$HACKMD_USER|g" "$DEST"
    fi

    # Cleanup sed backup files
    rm -f "${DEST}.bak"

    echo -e "${GREEN}  ✓ Installed: $FILENAME${NC}"
}

# Determine script directory (where the repo was cloned)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install selected skills
case $SKILL_CHOICE in
    1)
        customize_and_install "$SCRIPT_DIR/skills/daily-brief/daily-brief.md" "$CMD_DIR/daily-brief.md"
        ;;
    2)
        customize_and_install "$SCRIPT_DIR/skills/daily-brief/daily-brief.md" "$CMD_DIR/daily-brief.md"
        customize_and_install "$SCRIPT_DIR/skills/braindump/braindump.md" "$CMD_DIR/braindump.md"
        ;;
    3)
        customize_and_install "$SCRIPT_DIR/skills/daily-brief/daily-brief.md" "$CMD_DIR/daily-brief.md"
        customize_and_install "$SCRIPT_DIR/skills/meeting-transcript/meeting-transcript.md" "$CMD_DIR/meeting-transcript.md"
        ;;
    4)
        customize_and_install "$SCRIPT_DIR/skills/daily-brief/daily-brief.md" "$CMD_DIR/daily-brief.md"
        customize_and_install "$SCRIPT_DIR/skills/braindump/braindump.md" "$CMD_DIR/braindump.md"
        customize_and_install "$SCRIPT_DIR/skills/meeting-transcript/meeting-transcript.md" "$CMD_DIR/meeting-transcript.md"
        customize_and_install "$SCRIPT_DIR/skills/comprehensive-analysis/comprehensive-analysis.md" "$CMD_DIR/comprehensive-analysis.md"
        ;;
esac

echo ""
echo -e "${BLUE}Step 6: Check Prerequisites${NC}"
echo ""

# Check gh CLI
if command -v gh &> /dev/null; then
    if gh auth status &> /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ GitHub CLI (gh) — authenticated${NC}"
    else
        echo -e "${YELLOW}  ⚠ GitHub CLI (gh) — installed but not authenticated. Run: gh auth login${NC}"
    fi
else
    echo -e "${RED}  ✗ GitHub CLI (gh) — not installed. Install: https://cli.github.com/${NC}"
fi

# Check Claude Code
if command -v claude &> /dev/null; then
    echo -e "${GREEN}  ✓ Claude Code — installed${NC}"
else
    echo -e "${YELLOW}  ⚠ Claude Code — not found in PATH (may still work if installed elsewhere)${NC}"
fi

# MCP integration hints
echo ""
echo -e "${BLUE}Optional MCP Integrations:${NC}"
echo "  The skills work with just GitHub, but are more powerful with:"
echo ""
echo "  Linear MCP  — Issue tracking, initiative health, two-way sync"
echo "    → Add to .claude/settings or Claude Code MCP config"
echo ""
echo "  Slack MCP   — Team discussions, decisions, action items"
echo "    → Add to .claude/settings or Claude Code MCP config"
echo ""
echo "  PostHog MCP — Product analytics, metric trends, error correlation"
echo "    → Add to .claude/settings or Claude Code MCP config"
echo "    ⚠ Warning: PostHog can return large payloads. The skills are"
echo "      optimized for this, but keep an eye on context usage."
echo ""

# HackMD token
if [ -n "$HACKMD_USER" ]; then
    if [ -f ".claude/settings/hackmd-token" ] || [ -f "$HOME/.claude/settings/hackmd-token" ]; then
        echo -e "${GREEN}  ✓ HackMD token found${NC}"
    else
        echo -e "${YELLOW}  ⚠ HackMD username set but no token found.${NC}"
        echo "    Get a token from https://hackmd.io/settings#api"
        echo "    Save it to: $CMD_DIR/../settings/hackmd-token"
    fi
fi

echo ""
echo "================================================"
echo -e "${GREEN}  Setup Complete!${NC}"
echo "================================================"
echo ""
echo "  Start Claude Code and run:"
echo ""

case $SKILL_CHOICE in
    1) echo "    /daily-brief" ;;
    2) echo "    /daily-brief    — team intelligence brief"
       echo "    /braindump      — quick thought capture" ;;
    3) echo "    /daily-brief        — team intelligence brief"
       echo "    /meeting-transcript — process meeting notes" ;;
    4) echo "    /daily-brief              — daily team intelligence brief"
       echo "    /braindump                — quick thought capture"
       echo "    /meeting-transcript       — process meeting notes"
       echo "    /comprehensive-analysis   — deep weekly analysis" ;;
esac

echo ""
echo "  First run will take ~3-4 minutes as agents collect data."
echo "  Skills degrade gracefully — missing integrations are skipped."
echo ""
