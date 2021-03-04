#!/usr/bin/env bash

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"
DIR_IMAGES_RECOMPRESSED="$DIR_IMAGES/recompressed"

for DIR_SIZE in $(find "$DIR_IMAGES_DOWNLOADED" -type d -mindepth 1 -exec basename {} \; | sort -n); do
    DIR_OLD="$DIR_IMAGES_DOWNLOADED/$DIR_SIZE"
    DIR_NEW="$DIR_IMAGES_RECOMPRESSED/$DIR_SIZE"
    COUNT_OLD="$(ls -1 "$DIR_OLD" | wc -l | awk '{print $1}')"
    COUNT_NEW="$(ls -1 "$DIR_NEW" | wc -l | awk '{print $1}')"
    SIZE_OLD_DISPLAY="$(du -sh "$DIR_OLD" | awk '{print $1}')"
    SIZE_NEW_DISPLAY="$(du -sh "$DIR_NEW" | awk '{print $1}')"
    SIZE_OLD="$(du -s "$DIR_OLD" | awk '{print $1}')"
    SIZE_NEW="$(du -s "$DIR_NEW" | awk '{print $1}')"
    SIZE_PERCENT="$(printf "%0.2f\n" $(echo "$SIZE_NEW/$SIZE_OLD*100" | bc -l))% of original"
    echo "$DIR_SIZE: From $SIZE_OLD_DISPLAY to $SIZE_NEW_DISPLAY ($SIZE_PERCENT) (File count: $COUNT_OLD, $COUNT_NEW)"
done
