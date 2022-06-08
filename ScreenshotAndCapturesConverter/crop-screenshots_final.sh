#!/bin/bash

# 	In short:
#		Crops all the screenshots in $UNCROPPED_DIR, and
#		 puts them in $CROPPED_DIR.

#	Input directory and output directory
UNCROPPED_DIR="./Media/UncroppedScreenshot"
CROPPED_DIR="./Media/Screenshot"

#	Check if $UNCROPPED_DIR is empty
if [ ! -z $(find "$UNCROPPED_DIR/" -type d -empty) ] ;
	then
	#	If empty, then exit
		printf "$UNCROPPED_DIR/ is empty.\nTerminating.\n"
		exit 0
fi

#	Make sure that $CROPPED_DIR exists
mkdir -p $CROPPED_DIR

let i=0
#	Cycle through all files in $UNCROPPED_DIR
for filename in $UNCROPPED_DIR/*; do
	NAME="$filename"
	BASENAME="$(basename "$NAME")"

	printf "#$i: $NAME\n"

	INPUT_HEIGHT=$(identify -format "%[h]" "$NAME")
	SCREEN_HEIGHT=768

	CROP_WIDTH=1343
	CROP_HEIGHT=610
	CROP_LEFT=0
	CROP_TOP=66

	#CROP_TOP in case of double screen
	if [ $INPUT_HEIGHT -gt $SCREEN_HEIGHT ]
		then
			CROP_TOP=$(expr $INPUT_HEIGHT - $SCREEN_HEIGHT + $CROP_TOP)
	fi

	CROP_PAR="$CROP_WIDTH:$CROP_HEIGHT:$CROP_LEFT:$CROP_TOP"

	#	Crops screenshot, "$@" to add more option to ffmpeg
	ffmpeg "$@" -hide_banner -loglevel error -i "$NAME" -filter "crop=$CROP_PAR" "$CROPPED_DIR/$BASENAME"

	let i=i+1
done

printf "\nDone.\n"

exit 0
