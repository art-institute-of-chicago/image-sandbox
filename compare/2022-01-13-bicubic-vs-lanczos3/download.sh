#!/usr/bin/env bash

DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="${DIR_SCRIPT}/images"
DIR_BEFORE="${DIR_IMAGES}/before"
DIR_AFTER="${DIR_IMAGES}/after"

IMAGE_IDS=(
  # https://www.artic.edu/artworks/260219
  '70a5844c-019d-b645-f299-817aecbcfc9e'

  # https://www.artic.edu/artworks/258555
  '23842bbd-f0ea-2726-e87b-b9a6d80b6e87'

  # https://www.artic.edu/artworks/192885
  'fb06417d-c3b5-cb00-4e2a-fcff0bcc3db8'

  # https://www.artic.edu/artworks/83642
  'f9932dea-7999-ea96-fcab-965e027051c2'

  # https://www.artic.edu/artworks/100261
  '7135c1c1-f734-7a5e-e33b-714d3b776718'

  # https://www.artic.edu/artworks/214982
  '68e3a839-328f-314d-1a1a-be6bb0e4b304'

  # https://www.artic.edu/artworks/180574
  '5f32d5f0-3548-1059-f91c-3f94f0f35db3'

  # https://www.artic.edu/artworks/157158/unemployment-agency
  '8eec8935-b7c3-620e-b633-3e39fbf057af'
)


function download_image {
    STATUS="$(curl -s "https://${3}.artic.edu/iiif/2/${1}/full/843,/0/default.jpg" -w %{http_code} -m 5 --output "${2}")"

    if [ ! "${STATUS}" = "200" ]; then
        echo "Sorry, we are having trouble downloading the image. Try again later!" >&2
        exit 1
    fi
}

## now loop through the above array
for IMAGE_ID in "${IMAGE_IDS[@]}"; do
    download_image "${IMAGE_ID}" "${DIR_BEFORE}/${IMAGE_ID}.jpg" 'lakeimagesweb'
    download_image "${IMAGE_ID}" "${DIR_AFTER}/${IMAGE_ID}.jpg" 'lakeimagesweb-staging'
done
