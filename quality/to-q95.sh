#!/usr/bin/env bash

# This assumes that the downloaded images are at quality 100

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"
DIR_IMAGES_RECOMPRESSED="$DIR_IMAGES/q95"

find "$DIR_IMAGES_RECOMPRESSED" -name '*.jpg' -delete

for FILE_SOURCE in $(find "$DIR_IMAGES_DOWNLOADED" -name '*.jpg'); do
    FILE_DEST="$DIR_IMAGES_RECOMPRESSED/$(basename "$(dirname "$FILE_SOURCE")")/$(basename "$FILE_SOURCE")"
    convert -quality 95% "$FILE_SOURCE" "$FILE_DEST"
done
