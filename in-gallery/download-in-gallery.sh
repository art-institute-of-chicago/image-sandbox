#!/usr/bin/env bash

if ! [ -x "$(command -v jq)" ]; then
    echo 'Please install jq: https://stedolan.github.io/jq/' >&2
    exit 1
fi

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"
FILE_RESPONSE='/tmp/aic-images-download.json'
API_URL='https://api.artic.edu/api/v1/artworks'
API_QUERY='{
    "resources": "artworks",
    "ids": [
        129884,16571,14620,
        76244,27992,16568,
        20684,111628,117271,
        61128,117319,2189,
        137125,186049,24645,
        6565,28560,16549,
        14655,8991,80607
    ],
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

IMAGE_SIZE=843

for API_INDEX in $(seq $API_COUNT); do
    IMAGE_ID="$(echo "$API_RESPONSE" | jq -r ".data[$API_INDEX].image_id")"

    if [ "$IMAGE_ID" == 'null' ]; then
        continue;
    fi

    IS_PUBLIC_DOMAIN="$(echo "$API_RESPONSE" | jq -r ".data[$API_INDEX].is_public_domain")"

    FILE_IMAGE="$DIR_IMAGES_DOWNLOADED/$IMAGE_ID.jpg"

    if [ "$IMAGE_SIZE" -lt "844" ] || [ "$IS_PUBLIC_DOMAIN" == 'true' ]; then
        echo "$FILE_IMAGE downloading"

        if [ "$IMAGE_SIZE" -eq "3000" ]; then
            IMAGE_SIZE_URL='!3000,3000'
        else
            IMAGE_SIZE_URL="$IMAGE_SIZE,"
        fi

        STATUS="$(curl -s "https://lakeimagesweb.artic.edu/iiif/2/$IMAGE_ID/full/$IMAGE_SIZE_URL/0/default.jpg" -w %{http_code} -m 5 --output "$FILE_IMAGE")"

        if [ ! "$STATUS" = "200" ]; then
            echo "Sorry, we are having trouble downloading the image. Try again later!" >&2
            rm "$FILE_IMAGE"
            exit 1
        fi
    fi
done

# Clean up temporary files
if [ -f "$FILE_RESPONSE" ]; then
    rm "$FILE_RESPONSE"
fi
