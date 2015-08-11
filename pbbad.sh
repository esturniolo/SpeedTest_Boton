#!/bin/bash
#Speedtest Boton made by Emiliano Sturniolo <esturniolo@gmail.com>
#Use it as you want, be happy. Just remember me in every run :D

DIRDEST=/your/Dropbox/dir/watched/by/IFTTT
DIRTEMP=/go/to/temp/dir #Same as speedtest_boton.sh
FILETEMP=test_temporal.tmp
SPEEDDOWN=`awk '$0=$2' FS='Download: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`
SPEEDDUP=`awk '$0=$2' FS='Upload: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`

API="Your_Pushbullet_API_here"
MSG="My ISP speed sucks now! Download: $SPEEDDOWN Mbit/s / Upload: $SPEEDUP Mbit/s"

curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="ALERT - ISP" -d body="$MSG"

touch $DIRDEST/"Download $SPEEDDOWN- Upload $SPEEDUP"
