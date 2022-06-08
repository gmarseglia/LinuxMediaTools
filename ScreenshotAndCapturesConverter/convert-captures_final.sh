DIR_CAPTURES="./Media/Captures"
DIR_GIFS="./Media/GIFs"

#	Check if $DIR_CAPTURES is empty
if [ ! -z $(find "$DIR_CAPTURES" -empty -type d) ]
	then
	#	If empty, then exit
		printf "$DIR_CAPTURES is empty.\n\nDone.\n"
		exit 0
fi

#	Make sure $DIR_GIFS	exists
mkdir -p $DIR_GIFS

let i=0

for NAME in $DIR_CAPTURES/*.mp4
	do
		BASE=$(basename -s .mp4 "$NAME")

		printf "#$i: $NAME\n"

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

		printf "Starting conversion.\n"

		ffmpeg "$@" -loglevel warning -stats -i "$NAME" -filter_complex \
			"[0:v] crop=$CROP_PAR,scale=$SCALE_PAR,fps=$FPS,smartblur=$SMARTBLUR_PAR,setpts=PTS/$SPEEDUP_FACTOR,split [a][b];[a] palettegen [p];[b][p] paletteuse" \
			"$DIR_GIFS/$BASE.gif"

		let i=i+1
done

printf "\nDone.\n"
