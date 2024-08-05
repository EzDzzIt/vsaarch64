#!/bin/bash

folder2="Export_Code"
folder1="Export_Code_Original"

if [[ ! -d "$folder1" ]]; then
    echo "Folder $folder1 does not exist."
    exit 1
fi

if [[ ! -d "$folder2" ]]; then
    echo "Folder $folder2 does not exist."
    exit 1
fi

for file1 in "$folder1"/*; do
    filename=$(basename "$file1")
    file2="$folder2/$filename"
    logfile="Diff/$filename.diff"
    if [[ -f "$file2" ]]; then
        echo "Comparing $filename"
        diff -c "$file1" "$file2" >> "$logfile"
        
        if [[ $? -ne 0 ]]; then
            echo "Differences found in $filename"
        else
            echo "No differences in $filename"
            rm "$logfile"
        fi
    else
        echo "$filename does not exist in $folder2" >> "$logfile"
    fi
done

# Check for files in folder2 that are not in folder1
for file2 in "$folder2"/*; do
    filename=$(basename "$file2")
    file1="$folder1/$filename"
    
    if [[ ! -f "$file1" ]]; then
        echo "$filename does not exist in $folder1"
    fi
done
