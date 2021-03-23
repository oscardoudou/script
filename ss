#!/bin/bash
FILE=${1:?"required"}
sed -i '' -E 's/[[:space:]]*$//' "$FILE"
