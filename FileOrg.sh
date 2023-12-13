#!/bin/bash
# Author: Ali Waleed
# Github: github.com/sudobyter-hub

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Detect the operating system and set MOVE_COMMAND
case "$OSTYPE" in
  "linux-gnu"*) MOVE_COMMAND="rsync -a --progress --remove-source-files" ;;
  "darwin"*)    MOVE_COMMAND="mv" ;;
  "msys"|"cygwin") MOVE_COMMAND="robocopy" ;;
  *) echo -e "${RED}Unsupported OS. This script supports Linux, macOS, and Windows (Cygwin/MSYS).${RESET}"; exit 1 ;;
esac

# Main Loop
while true; do
    clear
    echo -e "${GREEN}Welcome, $USER. This is an advanced file organization tool.${RESET}"
    echo -e "${YELLOW}Enter source directory path (or 'q' to quit): ${RESET}"
    read -r src

    [[ "$src" == "q" ]] && break

    if [[ ! -d "$src" ]]; then
        echo -e "${RED}Source directory does not exist. Please enter a valid path.${RESET}"
        sleep 2
        continue
    fi

    echo -e "${BLUE}Detecting and categorizing files by extensions...${RESET}"
    declare -A extensions

    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            ext="${file##*.}"
            ext="${ext,,}"
            [[ -z "$ext" ]] && ext="unknown"
            ((extensions["$ext"]++))
        fi
    done < <(find "$src" -type f -print0)

    for ext in "${!extensions[@]}"; do
        echo -e "${GREEN}Detected ${extensions[$ext]} files with .$ext extension${RESET}"
    done

    echo -e "${GREEN}Total files detected: $(find "$src" -type f | wc -l)${RESET}"

    echo -e "${YELLOW}Enter destination directory path: ${RESET}"
    read -r dst

    [[ ! -d "$dst" ]] && echo -e "${BLUE}Creating destination directory...${RESET}" && mkdir -p "$dst"

    start_time=$(date +%s)

    echo -e "${BLUE}Moving files...${RESET}"
    for ext in "${!extensions[@]}"; do
        [[ "$ext" == "unknown" ]] && continue
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
            # Correctly format the robocopy command
            cmd="$MOVE_COMMAND \"$src\" \"$dst\" *.$ext /mov"
            eval $cmd
        else
            # Use rsync or mv for Linux and macOS
            $MOVE_COMMAND "$src"/*.$ext "$dst"
        fi
    done

    end_time=$(date +%s)
    execution_time=$((end_time - start_time))
    echo -e "${GREEN}DONE. Total files in $dst: $(find "$dst" -type f | wc -l)"
    echo -e "${GREEN}Execution time: $execution_time seconds${RESET}"

    echo -e "${YELLOW}Press Enter to continue or 'q' to quit${RESET}"
    read -r choice
    [[ "$choice" == "q" ]] && break
done

echo -e "${GREEN}Thank you for using the enhanced fileOrg tool. Have a great day!${RESET}"
