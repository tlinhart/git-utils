#!/usr/bin/env bash

PATTERN=${1:?"pattern is required"}
BASE_DIR=${BASE_DIR:-$(pwd)}
BASE_DIR=$(sed "s|//*|/|g; s|/*$||" <<< $BASE_DIR)

echo "Using base directory $BASE_DIR"
ls -d "$BASE_DIR"/*/ | while read dir; do
  (
    cd "$dir"
    remote=$(git remote | head -1)
    branch=$(git remote show $remote | sed -n '/HEAD branch/s/.*: //p')
    git ls-tree -r --name-only $remote/$branch | grep -q "$PATTERN" && echo "${dir%/}"
    git ls-tree -r --name-only $remote/$branch | grep --color=always "$PATTERN" | sed "s/^/    /"
  )
done
