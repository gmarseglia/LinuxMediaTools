if (( $# != 2 )) ;
	then
		printf "Incorrect use.\nCorrect use: scale.sh input_file target_directory\n"
		exit 1
fi

NAME="$1"
BASENAME="$(basename "$NAME")"

if [ -z "$2" ];
	then
		DIR_NAME="$(basename $0)-results";
	else
		DIR_NAME="$(basename $2)";
fi

mkdir -p $DIR_NAME

SCALE_WIDTH=-1
SCALE_HEIGHT=480

ffmpeg -i "$NAME" -filter "crop=$CROP_PAR,scale=$SCALE_WIDTH:$SCALE_HEIGHT" "$DIR_NAME/$BASENAME"
