#!/bin/bash

MAXSIZE=750M

# Check if the user provided a filename
if [ -z "$1" ]; then
    echo "Usage: $0 <bigfile>"
    exit 1
fi

# Get the input filename
BIGFILE="$1"

# Ensure the file exists
if [ ! -f "$BIGFILE" ]; then
    echo "Error: File '$BIGFILE' not found!"
    exit 1
fi

# Create a directory with the same name as the file (without extension)
DIRNAME="${BIGFILE%.*}"
mkdir -p "$DIRNAME"

# Split the file into 750MB chunks
split -b $MAXSIZE "$BIGFILE" "$DIRNAME/$BIGFILE"_part_

# Generate checksum file
CHECKSUM_FILE="$DIRNAME/checksum.txt"
echo "# Checksum:MD5" >> "$CHECKSUM_FILE"
md5sum "$BIGFILE" > "$CHECKSUM_FILE"
ls "$DIRNAME/" | grep "${BIGFILE##*/}_part_" | while read part; do md5sum "$DIRNAME/$part"; done >> "$CHECKSUM_FILE"


echo "Splitting complete! Files are stored in: $DIRNAME"
cat $CHECKSUM_FILE
