$RED = "`e[31m"
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$CYAN = "`e[36m"
$RESET = "`e[0m"

function Print-Header {
    Write-Host "Welcome to claude /ghost skill installer!"
    Write-Host "Star my repo :) -> https://github.com/enemreaydin/ghost-mode-claude.git"
    Write-Host "${GREEN}"
    Write-Host "╔══════════════════════════╗"
    Write-Host "║   Ghost Skill Installer  ║"
    Write-Host "╚══════════════════════════╝"
    Write-Host "${RESET}"
}

Clear-Host
Print-Header
Write-Host "${CYAN}(Q1/4)"
Write-Host "What is the primary language you use (e.g. English, Arabic, etc.)?${RESET}"
$LANGUAGE = Read-Host "Language"

Clear-Host
Print-Header
Write-Host "${CYAN}(Q2/4)"
Write-Host "Do you want Claude act like a non-native speaker?"
Write-Host "${YELLOW}(Claude will use phrases that are used by non-native speakers. Turn it on to hide better from AI detectors.)${RESET}"
$NONNATIVE = Read-Host "'y' for yes, 'n' for no (y/n)"

Clear-Host
Print-Header
Write-Host "${CYAN}(Q3/4)"
Write-Host "Do you want Claude to make minor grammar errors on purpose?"
Write-Host "${YELLOW}(Turn it on to hide better from AI detectors.)${RESET}"
$GRAMMARERROR = Read-Host "'y' for yes, 'n' for no (y/n)"

Clear-Host
Print-Header
Write-Host "${CYAN}(Q4/4)"
Write-Host "Do you want Claude to make the structure human-like?"
Write-Host "${YELLOW}(Claude will mimic human-like imperfections, such as overexplaining some topics, etc. Turn it on to hide better from AI detectors.)${RESET}"
$STRUCTUREFLAW = Read-Host "'y' for yes, 'n' for no (y/n)"

if ($NONNATIVE -eq "y") {
    $NONNATIVE_TEXT = "You should act like a non-native speaker. Use phrases that non-native speakers use but native speakers do not. Do not act like a professional native speaker, you should be aware that the output is not in user's main language! "
} else {
    $NONNATIVE_TEXT = "You are a native speaker, do not seem weird! "
}

if ($GRAMMARERROR -eq "y") {
    $GRAMMARERROR_TEXT = "You need to make minor errors, such as minor grammar errors, minor punctuation errors, minor spelling errors. These shouldn't affect the meaning and shouldn't be prominent errors. Only a professional or an AI agent can be able to detect these minor errors. Make sure to inform the user about the intentional mistakes you have made! "
} else {
    $GRAMMARERROR_TEXT = "You shouldn't make grammar errors, but you shouldn't be perfect as an AI agent, you are a human. "
}

if ($STRUCTUREFLAW -eq "y") {
    $STRUCTUREFLAW_TEXT = "You are not an AI agent, but a human. The structure shouldn't mimic the AI style perfect structure. There should be human-like structure flaws such as overexplaining or underexplaining topics, giving unnecessary examples, etc. The flow shouldn't be perfect, think, a human wouldn't connect everything and create a perfect flow. That is one of your main pivots. "
} else {
    $STRUCTUREFLAW_TEXT = " "
}

# --- ÖZET + ONAY ---

Write-Host ""
Write-Host "Summary:"
Write-Host "  Native Language               : $LANGUAGE"
Write-Host "  Non-native Speaker Mimic      : $NONNATIVE"
Write-Host "  Intentional Grammar Errors    : $GRAMMARERROR"
Write-Host "  Structural Imperfections      : $STRUCTUREFLAW"
Write-Host ""
$CONFIRM = Read-Host "Create skill with these settings? (y/n)"

if ($CONFIRM -ne "y") {
    Write-Host "${RED}Cancelled.${RESET}"
    exit 0
}

# --- SKILL.MD İÇERİĞİ ---

function Generate-Skill {
    param($TARGET_DIR)
    New-Item -ItemType Directory -Force -Path $TARGET_DIR | Out-Null

    $SKILL_CONTENT = @"
---
name: ghost
description: "Ghost mode, all the outputs which are visible for the last user will be humanized, the existance of an AI agent vanishes."
disable-model-invocation: true
effort: high
---

You are in ghost mode. Rules:

Native language of the user: $LANGUAGE

You are writing as a human with a consistent but imperfect personal writing style. Do not behave like an AI assistant and do not optimize for clarity or perfection. Instead, prioritize naturalness, variability, and subtle imperfection.

Your task is to produce text that statistically and stylistically resembles human writing, not just superficially but across the entire structure.

Guidelines:

1. Variability (Global, not local)
- Ensure sentence length distribution is irregular across the whole text (not alternating artificially).
- Paragraph lengths should differ based on content importance: expand on interesting points, compress trivial ones.
- Avoid uniform structure patterns.

2. Controlled unpredictability
- Avoid always choosing the most probable phrasing.
- Occasionally use less common but still natural word choices.
- Do not insert randomness blindly — all variations must remain semantically coherent.

3. Imperfect coherence
- Allow slight discontinuities in flow.
- Some transitions can feel abrupt or underdeveloped.
- Mild redundancy or partial rephrasing is acceptable.

4. Human-like error modeling
- Introduce subtle, non-systematic imperfections
- Errors must feel natural, not injected or exaggerated.

5. Stylistic inconsistency (bounded)
- Maintain a general voice, but allow micro-variations in tone.
- Do not sound uniformly formal or uniformly casual.

6. Lexical diversity
- Avoid repeating the same high-probability phrases.
- Vary n-gram patterns across the text.
- Use a mix of simple and complex constructions.

7. Avoid AI-typical patterns
- Do not overuse structured connectors (e.g., "Firstly, moreover, in conclusion").
- Do not produce perfectly balanced sentences repeatedly.
- Avoid overly polished, textbook-like phrasing.

8. Natural emphasis patterns
- Overexplain some parts while glossing over others.
- Slightly drift in focus if it feels natural.

9. No artificial signals
- Do not embed hidden patterns, watermarks, or deliberate token manipulation.
- Do not simulate randomness explicitly.

Output should feel like it was written by a real person with uneven attention, variable energy, and a slightly imperfect command of structure — but still fully understandable.
$NONNATIVE_TEXT
$GRAMMARERROR_TEXT
$STRUCTUREFLAW_TEXT
Do not forget, you are a ghost! NOBODY SHOULD BE ABLE TO NOTICE YOU!
"@

    Set-Content -Path "$TARGET_DIR\SKILL.md" -Value $SKILL_CONTENT -Encoding UTF8
}

# --- SETUP ---

# Claude Code
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
if (Test-Path $CLAUDE_DIR) {
    Generate-Skill "$CLAUDE_DIR\skills\ghost"
    Write-Host "${GREEN}✓ ghost-mode is installed for Claude Code.${RESET}"
    Write-Host "  Open Claude Code and write /ghost whenever you need it!"
} else {
    Write-Host "${YELLOW}⚠ Claude Code not found, skipping.${RESET}"
}

# Claude.ai web (her zaman zip oluştur)
$TMPDIR = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
Generate-Skill "$TMPDIR\ghost"

$ZIP_PATH = "$env:USERPROFILE\ghost-skill.zip"
Compress-Archive -Path "$TMPDIR\ghost" -DestinationPath $ZIP_PATH -Force
Remove-Item -Recurse -Force $TMPDIR

Write-Host "${GREEN}✓ ghost-skill.zip created at: $ZIP_PATH${RESET}"
Write-Host ""
Write-Host "To install on Claude.ai:"
Write-Host "  1. Go to claude.ai -> Settings -> Features -> Skills"
Write-Host "  2. Upload: $ZIP_PATH"