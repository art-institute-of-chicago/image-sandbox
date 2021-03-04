#!/usr/bin/env bash

if ! [ -x "$(command -v jq)" ]; then
    echo 'Please install jq: https://stedolan.github.io/jq/' >&2
    exit 1
fi

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"
DIR_IMAGES_RECOMPRESSED="$DIR_IMAGES/recompressed"

FILE_RESPONSE='/tmp/aic-images-download.json'
API_URL='https://api.artic.edu/api/v1/search'
API_QUERY='{
    "resources": "artworks",
    "limit": 50,
    "fields": [
        "id",
        "title",
        "image_id",
        "is_public_domain"
    ]
}'

STATUS="$(curl -s -H "Content-Type: application/json; charset=UTF-8" -d "$API_QUERY" -w %{http_code} -m 5 "$API_URL" -o "$FILE_RESPONSE")"

if [ ! "$STATUS" = "200" ]; then
    echo "Sorry, we are having trouble connecting to our API. Try again later!" >&2
    exit 1
fi

API_RESPONSE="$(cat "$FILE_RESPONSE")"
API_COUNT="$(echo "$API_RESPONSE" | jq -r '.data | length')"

IMAGE_SIZES=(200 400 600 843 1686)

for IMAGE_SIZE in "${IMAGE_SIZES[@]}"; do
    if [ ! -d "$DIR_IMAGES_DOWNLOADED/$IMAGE_SIZE" ]; then
        mkdir "$DIR_IMAGES_DOWNLOADED/$IMAGE_SIZE"
    fi
    if [ ! -d "$DIR_IMAGES_RECOMPRESSED/$IMAGE_SIZE" ]; then
        mkdir "$DIR_IMAGES_RECOMPRESSED/$IMAGE_SIZE"
    fi
done

for IMAGE_SIZE in "${IMAGE_SIZES[@]}"; do
    if [ ! -d "$DIR_IMAGES_DOWNLOADED/$IMAGE_SIZE" ]; then
        mkdir "$DIR_IMAGES_DOWNLOADED/$IMAGE_SIZE"
    fi
done

for API_INDEX in $(seq $API_COUNT); do
    IMAGE_ID="$(echo "$API_RESPONSE" | jq -r ".data[$API_INDEX].image_id")"

    if [ "$IMAGE_ID" == 'null' ]; then
        continue;
    fi

    IS_PUBLIC_DOMAIN="$(echo "$API_RESPONSE" | jq -r ".data[$API_INDEX].is_public_domain")"

    for IMAGE_SIZE in "${IMAGE_SIZES[@]}"; do
        FILE_IMAGE="$DIR_IMAGES_DOWNLOADED/$IMAGE_SIZE/$IMAGE_ID.jpg"

        if [ "$IMAGE_SIZE" -lt "844" ] || [ "$IS_PUBLIC_DOMAIN" == 'true' ]; then
            echo "$FILE_IMAGE downloading"

            STATUS="$(curl -s "https://lakeimagesweb.artic.edu/iiif/2/$IMAGE_ID/full/$IMAGE_SIZE,/0/default.jpg" -w %{http_code} -m 5 --output "$FILE_IMAGE")"

            if [ ! "$STATUS" = "200" ]; then
                echo "Sorry, we are having trouble downloading the image. Try again later!" >&2
                rm "$FILE_IMAGE"
                exit 1
            fi
        fi
    done
done

# Clean up temporary files
if [ -f "$FILE_RESPONSE" ]; then
    rm "$FILE_RESPONSE"
fi
