if (( $# != 2 ));
	then
		printf "Incorrect usage.\nCorrect usage: crop-excel.sh input_file result_directory\n"
		exit 1
fi

NAME="$1"
BASENAME="$(basename "$NAME")"

if [ -z "$2" ];
	then
		DIR_NAME="$(basename $0)-Results";
	else
		DIR_NAME="$(basename $2)";
fi

mkdir -p $DIR_NAME

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

ffmpeg -hide_banner -loglevel error -i "$NAME" -filter "crop=$CROP_PAR" "$DIR_NAME/$BASENAME"
