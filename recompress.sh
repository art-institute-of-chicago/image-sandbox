#!/usr/bin/env bash

if ! [ -x "$(command -v jpeg-recompress)" ]; then
    echo 'Please install jpeg-recompress: https://github.com/danielgtaylor/jpeg-archive' >&2
    exit 1
fi

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"
DIR_IMAGES_RECOMPRESSED="$DIR_IMAGES/recompressed"

find "$DIR_IMAGES_RECOMPRESSED" -name '*.jpg' -delete

for FILE_SOURCE in $(find "$DIR_IMAGES_DOWNLOADED" -name '*.jpg'); do
    FILE_DEST="$DIR_IMAGES_RECOMPRESSED/$(basename "$(dirname "$FILE_SOURCE")")/$(basename "$FILE_SOURCE")"
    jpeg-recompress "$FILE_SOURCE" "$FILE_DEST"
done
