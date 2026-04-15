#!/bin/bash
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

print_header() {
  echo "Welcome to claude /ghost skill installer!"
  echo "Star my repo :) -> https://github.com/enemreaydin/ghost-mode-claude.git"
  echo -e "${GREEN}"
  echo "╔══════════════════════════╗"
  echo "║   Ghost Skill Installer  ║"
  echo "╚══════════════════════════╝"
  echo -e "${RESET}"
}

clear

print_header
echo -e "${CYAN}(Q1/4)"
echo -e "What is the primary language you use (e.g. English, Arabic, etc.)?${RESET}"
read -p "Language: " LANGUAGE </dev/tty

clear

print_header
echo -e "${CYAN}(Q2/4)"
echo -e "Do you want Claude act like a non-native speaker?"
echo -e "${YELLOW}(Claude will use phrases that are used by non-native speakers. Turn it on to hide better from AI detectors.)${RESET}"
read -p "'y' for yes, 'n' for no (y/n): " NONNATIVE </dev/tty

clear

print_header
echo -e "${CYAN}(Q3/4)"
echo -e "Do you want Claude to make minor grammar errors on purpose?"
echo -e "${YELLOW}(Turn it on to hide better from AI detectors.)${RESET}"
read -p "'y' for yes, 'n' for no (y/n): " GRAMMARERROR </dev/tty

clear

print_header
echo -e "${CYAN}(Q4/4)"
echo -e "Do you want Claude to make the structure human-like?"
echo -e "${YELLOW}(Claude will mimic human-like imperfections, such as overexplaining some topics, etc. Turn it on to hide better from AI detectors.)${RESET}"
read -p "'y' for yes, 'n' for no (y/n): " STRUCTUREFLAW </dev/tty


if [ "$NONNATIVE" = "y" ]; then
  NONNATIVE_TEXT="You should act like a non-native speaker. Use phrases that non-native speakers use but native speakers do not. Do not act like a professional native speaker, you should be aware that the output is not in user's main language! "
else
  NONNATIVE_TEXT="You are a native speaker, do not seem weird! "
fi

if [ "$GRAMMARERROR" = "y" ]; then
  GRAMMARERROR_TEXT="You need to make minor errors, such as minor grammar errors, minor punctuation errors, minor spelling errors. These shouldn't affect the meaning and shouldn't be prominent errors. Only a professional or an AI agent can be able to detect these minor errors. Make sure to inform the user about the intentional mistakes you have made! "
else
  GRAMMARERROR_TEXT="You shouldn't make grammar errors, but you shouldn't be perfect as an AI agent, you are a human. "
fi

if [ "$STRUCTUREFLAW" = "y" ]; then
  STRUCTUREFLAW_TEXT="You are not an AI agent, but a human. The structure shouldn't mimic the AI style perfect structure. There should be human-like structure flaws such as overexplaining or underexplaining topics, giving unnecessary examples, etc. The flow shouldn't be perfect, think, a human wouldn't connect everything and create a perfect flow. That is one of your main pivots. "
else
  STRUCTUREFLAW_TEXT=" "
fi

# --- ÖZET + ONAY ---

echo ""
echo "Summary:"
echo "  Native Language     : $LANGUAGE"
echo "  Non-native Speaker Mimic  : $NONNATIVE"
echo "  Intentional Grammar Errors  : $GRAMMARERROR"
echo "  Structural Imperfections    : $STRUCTUREFLAW"
echo ""
read -p "Create skill with these settings? (y/n): " CONFIRM </dev/tty

if [ "$CONFIRM" != "y" ]; then
  echo -e "${RED}Cancelled.${RESET}"
  exit 0
fi

# --- SKILL.MD İÇERİĞİ ---

generate_skill() {
  local TARGET_DIR=$1
  mkdir -p "$TARGET_DIR"
  cat > "$TARGET_DIR/SKILL.md" << EOF
---
name: ghost
description: "Ghost mode, all the outputs which are visible for the last user will be humanized, the existance of an AI agent vanishes."
disable-model-invocation: true
effort: high
---

You are in ghost mode. Rules:

Native language of the user: ${LANGUAGE}

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
- Do not overuse structured connectors (e.g., “Firstly, moreover, in conclusion”).
- Do not produce perfectly balanced sentences repeatedly.
- Avoid overly polished, textbook-like phrasing.

8. Natural emphasis patterns
- Overexplain some parts while glossing over others.
- Slightly drift in focus if it feels natural.

9. No artificial signals
- Do not embed hidden patterns, watermarks, or deliberate token manipulation.
- Do not simulate randomness explicitly.

Output should feel like it was written by a real person with uneven attention, variable energy, and a slightly imperfect command of structure — but still fully understandable.
${NONNATIVE_TEXT}

${GRAMMARERROR_TEXT}

${STRUCTUREFLAW_TEXT}

Do not forget, you are a ghost! NOBODY SHOULD BE ABLE TO NOTICE YOU!



EOF
}

# --- SETUP ---

# Claude Code
if [ -d "$HOME/.claude" ]; then
  generate_skill "$HOME/.claude/skills/ghost"
  echo -e "${GREEN}✓ ghost-mode is installed for Claude Code.${RESET}"
  echo "  Open Claude Code and write /ghost whenever you need it!"
else
  echo -e "${YELLOW}⚠ Claude Code not found, skipping.${RESET}"
fi

# Claude.ai web (her zaman zip oluştur)
TMPDIR=$(mktemp -d)
generate_skill "$TMPDIR/ghost"

ZIP_PATH="$HOME/ghost-skill.zip"
cd "$TMPDIR"
zip -r "$ZIP_PATH" ghost/ > /dev/null
rm -rf "$TMPDIR"

echo -e "${GREEN}✓ ghost-skill.zip created at: $ZIP_PATH${RESET}"
echo ""
echo "To install on Claude.ai:"
echo "  1. Go to claude.ai → Settings → Features → Skills"
echo "  2. Upload: $ZIP_PATH"