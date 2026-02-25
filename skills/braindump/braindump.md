# Brain Dump Command

## Purpose
Quick capture and initial processing of stream-of-consciousness thoughts, ideas, and insights with immediate domain classification and basic structuring.

**IMPORTANT:** This command is for **personal thoughts and quick captures ONLY**.
- **For Meeting Transcripts:** Use `/meeting-transcript` command instead
- **For Synthesis Analysis:** Use `/brain-dump-analysis` command to synthesize multiple braindumps

## Command: `/braindump`

## Parallel Processing Strategy

**Use a background agent to gather context while processing the braindump.**

### Background Context Enrichment
While the orchestrator processes the raw braindump, launch one background agent:

#### Agent: "context-enricher" (subagent_type: general-purpose, run_in_background: true)
```
Gather enrichment context for the braindump being processed.

1. Read recent braindumps in the same domain for connection-finding
2. If project-related content detected: read latest relevant project files
3. Check [CUSTOMIZE: path/to/knowledge/] for related frameworks or insights to cross-reference
4. If competitor names mentioned: WebSearch for latest news on those competitors

Return: Related braindumps, competitive context, framework connections, recent competitor news.
```

The orchestrator uses this context to:
- Identify connections to previous braindumps
- Enrich competitive intelligence sections
- Cross-reference with existing frameworks
- Update competitor files if new intel found

## Content Type Detection

### Is this a Meeting Transcript?
**Indicators:**
- Has attendees listed
- Contains dialogue between multiple people
- Has meeting metadata (duration, recording URL, etc.)
- Structured as a meeting discussion

**If YES → This is a MEETING, not a braindump**
- Type: `meeting-notes`
- Location: `[CUSTOMIZE: path/to/meetings/]YYYY-MM-DD-topic.md`

### Is this a Personal Thought/Quick Capture?
**Indicators:**
- Stream-of-consciousness from one person
- Quick thoughts, ideas, observations
- Personal reflections or brainstorming
- No structured meeting format

**If YES → This is a BRAINDUMP**
- Type: `braindump`
- Location: `[CUSTOMIZE: path/to/braindumps/]braindump-YYYY-MM-DD-HHMM-topic.md`

## Process Flow

### 1. Rapid Capture
- Accept any format: voice, text, scattered thoughts
- No judgment or filtering during initial capture
- Preserve original voice and spontaneity
- Capture timestamp and context

### 2. Initial Processing
- Basic cleanup and structure without losing authenticity
- Identify main themes and concepts
- Extract obvious action items or decisions
- Note emotional tone and energy level

### 3. Quick Domain Classification
- **Personal:** Individual growth, relationships, wellness
- **Professional:** Work, leadership, career development
- **Project-Specific:** Related to specific projects or initiatives
- **Mixed/Unclear:** Requires further analysis

### 3a. Competitive Intelligence Detection (Optional)
**If braindump mentions competitors, automatically extract and update:**
- **Trigger:** Any mention of competitor names, funding rounds, ARR/MRR, competitive positioning
- **Action**: Extract competitor information to `[CUSTOMIZE: path/to/competitive/][competitor-name].md`
- **Update**: Add dated entry to existing competitor file or create new one
- **Cross-reference**: Link back to original braindump source

### 4. Immediate Structuring
- Separate different topics or themes
- Identify questions vs. statements vs. ideas
- Flag urgent items requiring immediate attention
- Note connections to existing knowledge

### 5. Output Generation
- Save to appropriate domain braindump folder
- Tag for later analysis
- Create quick summary for immediate reference

## Metadata Template
```yaml
---
type: "braindump"
domain: "[personal|professional|project-specific|mixed]"
project: "[project-name]" # Only if project-specific
date: "YYYY-MM-DD"
created: "YYYY-MM-DD HH:MM"
capture_method: "[voice|text|mixed]"
energy_level: "[high|medium|low]"
emotional_tone: "[excited|frustrated|curious|concerned|neutral]"
themes: ["theme1", "theme2", "theme3"]
urgency: "[immediate|soon|eventual|none]"
analysis_needed: [true|false]
tags:
  - braindump
  - raw-thoughts
  - domain-tag
status: "[captured|needs-analysis|processed]"
---
```

## Capture Guidelines

### What to Include
- **Stream of Consciousness:** Raw, unfiltered thoughts
- **Ideas and Insights:** Creative thoughts and realizations
- **Problems and Challenges:** Issues you're wrestling with
- **Questions:** Things you're wondering about
- **Decisions:** Choices you're considering
- **Observations:** Things you've noticed or learned
- **Emotions:** How you're feeling about situations
- **Connections:** Links between different concepts

### What NOT to Filter
- **Incomplete Thoughts:** Half-formed ideas are valuable
- **Contradictions:** Conflicting thoughts show thinking process
- **Repetition:** Recurring themes indicate importance
- **Tangents:** Side thoughts often contain insights
- **Emotions:** Feelings provide important context
- **Questions:** Uncertainty is part of the process

## Domain Classification Quick Guide

### Personal Domain Indicators
- Family, relationships, personal health
- Individual goals and aspirations
- Personal learning and growth
- Life balance and satisfaction

### Professional Domain Indicators
- Work projects and responsibilities
- Team dynamics and leadership
- Career development and skills
- Industry trends and opportunities

### Project-Specific Indicators
- Specific product or initiative names
- Technical implementation details
- Project timelines and milestones
- Project-specific metrics or goals

### Mixed Domain Indicators
- Cross-cutting themes affecting multiple areas
- Life philosophy and principles
- Time management and productivity
- Strategic thinking and planning

## Processing Levels

### Level 1: Raw Capture (This Command)
- Immediate capture with minimal processing
- Basic domain classification
- Simple structuring and cleanup
- Quick metadata tagging

### Level 2: Analysis Processing (brain-dump-analysis command)
- Deep thematic analysis
- Strategic insight extraction
- Knowledge base integration
- Actionable recommendation generation

### Level 3: Knowledge Integration (consolidation command)
- Pattern recognition across multiple braindumps
- Framework development from insights
- Timeline narrative creation
- Single source of truth updates

## Output Structure

### 1. Original Capture
```markdown
## Raw Thoughts
[Preserve original voice and flow]
```

### 2. Quick Structure
```markdown
## Main Themes
- Theme 1: Brief description
- Theme 2: Brief description
- Theme 3: Brief description

## Action Items
- [ ] Urgent item requiring immediate attention
- [ ] Important item for this week
- [ ] Future consideration

## Questions
- Question 1 requiring research or thought
- Question 2 needing discussion with others
- Question 3 for future exploration

## Connections
- Link to existing project or knowledge
- Relationship to previous braindumps
- Connection to current priorities
```

### 3. Processing Notes
```markdown
## Processing Notes
- Domain: [Classification reasoning]
- Energy: [Energy level during capture]
- Context: [Situational context if relevant]
- Next Steps: [Immediate follow-up needed]
```

## File Naming Convention

### For Braindumps (Quick Captures)
- **Personal:** `[CUSTOMIZE: path/to/personal/]braindumps/braindump-YYYY-MM-DD-HHMM-<title>.md`
- **Professional:** `[CUSTOMIZE: path/to/professional/]braindumps/braindump-YYYY-MM-DD-HHMM-<title>.md`
- **Project-Specific:** `[CUSTOMIZE: path/to/projects/][project]/braindumps/braindump-YYYY-MM-DD-HHMM-<title>.md`
- **Mixed:** `[CUSTOMIZE: path/to/inbox/]braindump-YYYY-MM-DD-HHMM-<title>.md` (for later classification)

### For Meetings (if detected)
- Redirect to `/meeting-transcript` command

## Quality Guidelines

### Authenticity Preservation
- Maintain original voice and tone
- Preserve emotional context and energy
- Keep incomplete thoughts and questions
- Don't over-structure or sanitize

### Useful Structure
- Separate clearly different topics
- Identify actionable items
- Note time-sensitive elements
- Flag items needing follow-up

### Context Capture
- Note situational context if relevant
- Capture emotional state and energy level
- Record any triggering events or conversations
- Include relevant background information

## Integration with Other Commands

### Immediate Follow-up
- Use `/brain-dump-analysis` for deeper processing of accumulated braindumps
- Use `/daily-brief` — braindumps feed into the "Strategic Context" section automatically

### Scheduled Processing
- Weekly review of accumulated braindumps
- Monthly pattern analysis across braindumps
- Quarterly integration into knowledge consolidation

### Cross-Reference Creation
- Link to related previous braindumps
- Connect to relevant project documents
- Reference related insights and frameworks

## Common Use Cases

### Problem-Solving Sessions
- Capture all aspects of a complex problem
- Record different solution approaches
- Note pros and cons of various options
- Document decision-making process

### Creative Ideation
- Capture creative ideas without judgment
- Record inspiration sources and triggers
- Note connections between different concepts

### Strategic Thinking
- Process complex strategic decisions
- Explore different scenarios and implications
- Consider stakeholder perspectives

### Learning Integration
- Process new information and insights
- Connect learning to existing knowledge
- Identify application opportunities

### Emotional Processing
- Work through challenging situations
- Process feedback or difficult conversations
- Identify patterns in emotional responses
