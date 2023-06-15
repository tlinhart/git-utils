#!/usr/bin/env bash

BASE_DIR=${BASE_DIR:-$(pwd)}
BASE_DIR=$(sed "s|//*|/|g; s|/*$||" <<< $BASE_DIR)

echo "Using base directory $BASE_DIR"
ls -d "$BASE_DIR"/*/ | while read dir; do
  (
    echo "Stepping into $dir"
    cd "$dir"
    git fetch --all -p
  )
done
