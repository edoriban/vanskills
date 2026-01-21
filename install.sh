#!/usr/bin/env bash
# VanSkills - Remote Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/vandev/vanskills/main/install.sh | bash
#
# Options (via env vars):
#   VANSKILLS_DIR=~/vanskills     Where to clone vanskills
#   VANSKILLS_TARGET=.            Target project directory
#   VANSKILLS_ASSISTANT=claude    AI assistant (claude|gemini|codex|copilot|all)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Defaults
VANSKILLS_DIR="${VANSKILLS_DIR:-$HOME/vanskills}"
VANSKILLS_TARGET="${VANSKILLS_TARGET:-$(pwd)}"
VANSKILLS_ASSISTANT="${VANSKILLS_ASSISTANT:-}"
VANSKILLS_REPO="https://github.com/vandev/vanskills.git"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║         VanSkills Installer           ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Clone or update vanskills
if [ -d "$VANSKILLS_DIR" ]; then
    echo -e "${CYAN}Updating vanskills...${NC}"
    git -C "$VANSKILLS_DIR" pull --quiet 2>/dev/null || true
else
    echo -e "${CYAN}Cloning vanskills to $VANSKILLS_DIR...${NC}"
    git clone --quiet "$VANSKILLS_REPO" "$VANSKILLS_DIR"
fi

# Step 2: Run the installer
echo -e "${CYAN}Installing skills to $VANSKILLS_TARGET...${NC}"
echo ""

if [ -n "$VANSKILLS_ASSISTANT" ]; then
    # Non-interactive mode
    case "$VANSKILLS_ASSISTANT" in
        all)
            "$VANSKILLS_DIR/bin/install" --target "$VANSKILLS_TARGET" --all
            ;;
        claude|gemini|codex|copilot)
            "$VANSKILLS_DIR/bin/install" --target "$VANSKILLS_TARGET" --"$VANSKILLS_ASSISTANT"
            ;;
        *)
            echo -e "${RED}Unknown assistant: $VANSKILLS_ASSISTANT${NC}"
            echo "Valid options: claude, gemini, codex, copilot, all"
            exit 1
            ;;
    esac
else
    # Interactive mode
    "$VANSKILLS_DIR/bin/install" --target "$VANSKILLS_TARGET"
fi

echo ""
echo -e "${GREEN}Done! Skills installed successfully.${NC}"
echo ""
echo -e "VanSkills location: ${CYAN}$VANSKILLS_DIR${NC}"
echo -e "To update skills:   ${CYAN}cd $VANSKILLS_DIR && git pull${NC}"
echo -e "To add more skills: ${CYAN}$VANSKILLS_DIR/bin/install${NC}"
