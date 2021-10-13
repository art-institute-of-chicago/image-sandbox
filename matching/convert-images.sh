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

IMAGE_CONVERTS=("scale-proportional" "scale-disproportional" "crop" "rotate" "color-shift")
for IMAGE_CONVERT in "${IMAGE_CONVERTS[@]}"; do
	if [ ! -d "$DIR_IMAGES/$IMAGE_CONVERT" ]; then
		mkdir "$DIR_IMAGES/$IMAGE_CONVERT"
	fi
done

IMAGE_RESIZES=("50%" "25%" "150%" "200%")
for IMAGE_RESIZE in "${IMAGE_RESIZES[@]}"; do 
	cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/scale-proportional/$IMAGE_RESIZE"
	cd "$DIR_IMAGES/scale-proportional/$IMAGE_RESIZE"
	mogrify -resize $IMAGE_RESIZE *.jpg
	cd ../../../
	echo $PWD
done

IMAGE_ROTATES=("90" "180" "270" "23" "45" "67" "156")
for IMAGE_ROTATE in "${IMAGE_ROTATES[@]}"; do
        cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/rotate/$IMAGE_ROTATE"
        cd "$DIR_IMAGES/rotate/$IMAGE_ROTATE"
        mogrify -rotate -$IMAGE_ROTATE *.jpg
        cd ../../../
        echo $PWD
done

IMAGE_COLORS=("-negate" "-colorspace Gray" "+level-colors red,yellow" "+level-colors yellow,blue" "+level-colors blue,red" "+level 20%" "-level 20%")
for IMAGE_COLOR in "${IMAGE_COLORS[@]}"; do
        cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/color-shift/$IMAGE_COLOR"
        cd "$DIR_IMAGES/color-shift/$IMAGE_COLOR"
	mogrify $IMAGE_COLOR *.jpg
        cd ../../../
        echo $PWD
done

IMAGE_CROPS=("NorthWest" "NorthEast" "Center" "SouthWest" "SouthEast")
for IMAGE_CROP in "${IMAGE_CROPS[@]}"; do
	cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/crop/$IMAGE_CROP"
	cd "$DIR_IMAGES/crop/$IMAGE_CROP"
	mogrify -gravity $IMAGE_CROP -crop 50%x+0+0 *.jpg
	cd ../../../
	echo $PWD
done

IMAGE_SCALE_DISPS=("500x843" "250x843" "100x843" "843x500" "843x250" "843x100")
for IMAGE_SCALE_DISP in "${IMAGE_SCALE_DISPS[@]}"; do 
	cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/scale-disproportional/$IMAGE_SCALE_DISP"
	cd "$DIR_IMAGES/scale-disproportional/$IMAGE_SCALE_DISP"
	mogrify -resize $IMAGE_SCALE_DISP! *.jpg
	cd ../../../
	echo $PWD
done

IMAGE_EXIFS=("Comment")
if [ -d "$DIR_IMAGES_DOWNLOADED" ]; then
	cp -r "$DIR_IMAGES_DOWNLOADED" "$DIR_IMAGES/change-exif"
	cd "$DIR_IMAGES/change-exif"
	for FILE in *; do 
		exiftool -Comment="exif edited" $FILE
	done
	cd ../../
fi

# Clean up temporary files
if [ -f "$FILE_RESPONSE" ]; then
    rm "$FILE_RESPONSE"
fi

