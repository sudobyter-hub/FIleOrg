#!/bin/bash
# Author: Ali Waleed
# Github: github.com/sudobyter-hub

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    MOVE_COMMAND="rsync -a --progress --remove-source-files"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    MOVE_COMMAND="mv"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows (Cygwin/MSYS)
    MOVE_COMMAND="robocopy"
else
    echo -e "${RED}Unsupported operating system. This script is compatible with Linux, macOS, and Windows (Cygwin/MSYS)."
    exit 1
fi

while :
do
    clear  # Clear the terminal screen for a clean interface

    echo -e "${GREEN}Welcome, $USER"
    echo -e "${RED}Please enter the source directory path (or 'q' to quit): "
    read src

    if [ "$src" = "q" ]; then
        break
    fi

    if [ ! -d "$src" ]; then
        echo -e "${RED}Source directory does not exist. Please enter a valid path."
        continue
    fi

    echo -e "${RED}Detecting and categorizing files by extensions..."

    # Create an associative array to store file counts by extension
    declare -A extensions

    # Loop through files in the source directory and categorize them
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            # Extract the file extension (if any) and categorize it
            ext=$(basename "$file" | awk -F'.' '{print tolower($NF)}')
            if [ -z "$ext" ]; then
                ext="unknown"
            fi
            ((extensions["$ext"]++))
        fi
    done < <(find "$src" -type f -print0)

    # Display detected extensions and counts
    for ext in "${!extensions[@]}"; do
        echo -e "${GREEN}Detected ${extensions[$ext]} files with .$ext extension"
    done

    echo -e "${GREEN}Total files detected: $(find "$src" -type f | wc -l)"

    # Prompt for the destination directory
    echo -e "${GREEN}Enter the destination directory path: "
    read dst

    if [ ! -d "$dst" ]; then
        echo -e "${RED}Destination directory does not exist. Creating it..."
        mkdir -p "$dst"
    fi

    # Measure execution time
    start_time=$(date +%s)

    # Move files based on their detected extensions with real progress
    for ext in "${!extensions[@]}"; do
        if [ "$ext" = "unknown" ]; then
            continue
        fi
        $MOVE_COMMAND "$src" "$dst" /MOV /E /Z /DCOPY:T /XF "*.$ext" /XD "*"
    done

    end_time=$(date +%s)
    execution_time=$((end_time - start_time))

    echo -e "${GREEN}DONE. Total files in $dst: $(find "$dst" -type f | wc -l)"
    echo -e "${GREEN}Execution time: $execution_time seconds"

    echo -e "${YELLOW}Press Enter to continue or 'q' to quit"
    read choice

    if [ "$choice" = "q" ]; then
        break
    fi
done

echo -e "${GREEN}Thank you for using the fileOrg. Have a great day!"
