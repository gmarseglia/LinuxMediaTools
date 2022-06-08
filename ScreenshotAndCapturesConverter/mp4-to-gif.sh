if (( $# < 1 ))
	then
		printf "Incorrect usage.\nCorrect usage: $(basename $0) input_file [target_directory]\n"
		exit 1
fi

NAME="$1"
BASE=$(basename -s .mp4 "$NAME")

if [ -z "$2" ]
	then
		DIR_NAME="$(basename "$0")-results"
	else
		DIR_NAME="$(basename "$2")"
fi

mkdir -p $DIR_NAME

CROP_WIDTH=1343
CROP_HEIGHT=614
CROP_LEFT=0
CROP_TOP=66

#CROP_TOP in case of double screen
INPUT_HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$NAME")
SCREEN_HEIGHT=768
if (( $INPUT_HEIGHT > $SCREEN_HEIGHT ))
	then
		CROP_TOP=$(expr $INPUT_HEIGHT - $SCREEN_HEIGHT + $CROP_TOP)
fi

CROP_PAR="$CROP_WIDTH:$CROP_HEIGHT:$CROP_LEFT:$CROP_TOP"

SCALE_WIDTH=-1
SCALE_HEIGHT=480
SCALE_PAR="$SCALE_WIDTH:$SCALE_HEIGHT"

FPS="15"

SMARTBLUR_PAR="1.5:-0.35:-3.5:0.65:0.25:2.0"

SPEEDUP_FACTOR=2.0

printf "$NAME:\n"
ffmpeg  -loglevel warning -stats -i "$NAME" -filter_complex \
	"[0:v] crop=$CROP_PAR,scale=$SCALE_PAR,fps=$FPS,smartblur=$SMARTBLUR_PAR,setpts=PTS/$SPEEDUP_FACTOR,split [a][b];[a] palettegen [p];[b][p] paletteuse" \
	"$DIR_NAME/$BASE.gif"