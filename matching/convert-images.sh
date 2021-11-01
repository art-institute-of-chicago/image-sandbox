#!/usr/bin/env bash

if ! [ -x "$(command -v exiftool)" ]; then
    echo 'Please install exiftool: $ brew install exiftool' >&2
    exit 1
fi

if ! [ -x "$(command -v convert)" ]; then
    echo 'Please install imagemagick: $ brew install imagemagick' >&2
    exit 1
fi
  
DIR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")"
DIR_IMAGES="$DIR_SCRIPT/images"
DIR_IMAGES_DOWNLOADED="$DIR_IMAGES/downloaded"

IMAGE_SIZE=843

IMAGE_CONVERTS=("scale-proportional" "scale-disproportional" "crop" "rotate" "color-shift" "change-exif")
for IMAGE_CONVERT in "${IMAGE_CONVERTS[@]}"; do
    if [ ! -d "$DIR_IMAGES/$IMAGE_CONVERT" ]; then
        mkdir "$DIR_IMAGES/$IMAGE_CONVERT"
    fi
done

IMAGE_RESIZES=("50%" "25%" "150%" "200%")
for IMAGE_RESIZE in "${IMAGE_RESIZES[@]}"; do 
    mkdir "$DIR_IMAGES/scale-proportional/$IMAGE_RESIZE" 
    mogrify -resize $IMAGE_RESIZE -path "$DIR_IMAGES/scale-proportional/$IMAGE_RESIZE" "$DIR_IMAGES_DOWNLOADED/"*.jpg
done

IMAGE_ROTATES=("90" "180" "270" "23" "45" "67" "156")
for IMAGE_ROTATE in "${IMAGE_ROTATES[@]}"; do
    mkdir "$DIR_IMAGES/rotate/$IMAGE_ROTATE"
    mogrify -rotate -$IMAGE_ROTATE -path "$DIR_IMAGES/rotate/$IMAGE_ROTATE" "$DIR_IMAGES_DOWNLOADED/"*.jpg
done

IMAGE_COLORS=("-negate" "-colorspace Gray" "+level-colors red,yellow" "+level-colors yellow,blue" "+level-colors blue,red" "+level 20%" "-level 20%")
for IMAGE_COLOR in "${IMAGE_COLORS[@]}"; do
    mkdir "$DIR_IMAGES/color-shift/$IMAGE_COLOR"
    mogrify $IMAGE_COLOR -path "$DIR_IMAGES/color-shift/$IMAGE_COLOR" "$DIR_IMAGES_DOWNLOADED/"*.jpg
done

IMAGE_CROPS=("NorthWest" "NorthEast" "Center" "SouthWest" "SouthEast")
for IMAGE_CROP in "${IMAGE_CROPS[@]}"; do
    mkdir "$DIR_IMAGES/crop/$IMAGE_CROP"
    mogrify -gravity $IMAGE_CROP -crop 50%x+0+0 -path "$DIR_IMAGES/crop/$IMAGE_CROP" "$DIR_IMAGES_DOWNLOADED/"*.jpg
done

IMAGE_SCALE_DISPS=("500x843" "250x843" "100x843" "843x500" "843x250" "843x100")
for IMAGE_SCALE_DISP in "${IMAGE_SCALE_DISPS[@]}"; do
    mkdir "$DIR_IMAGES/scale-disproportional/$IMAGE_SCALE_DISP" 
    mogrify -resize $IMAGE_SCALE_DISP! -path "$DIR_IMAGES/scale-disproportional/$IMAGE_SCALE_DISP" "$DIR_IMAGES_DOWNLOADED/"*.jpg
done

if [ -d "$DIR_IMAGES_DOWNLOADED" ]; then
    if [ "$(ls -A "$DIR_IMAGES/change-exif")" ]; then
        rm -r "$DIR_IMAGES/change-exif"
        mkdir "$DIR_IMAGES/change-exif"
    fi
    exiftool -Comment="exif edited" -o "$DIR_IMAGES/change-exif" "$DIR_IMAGES_DOWNLOADED"
fi
