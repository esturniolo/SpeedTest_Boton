#!/bin/bash
#Speedtest Boton made by Emiliano Sturniolo <esturniolo@gmail.com>
#Use it as you want, be happy. Just remember me in every run :D

function copy {

DIRDEST=/your/Dropbox/dir/watched/by/IFTTT
DIRTEMP=/go/to/temp/dir #Same as speedtest_boton.sh
FILETEMP=$DIRTEMP/ifttt_temporal.tmp
ORIGINALTEMP=$DIRTEMP/test_temporal.tmp

cp $ORIGINALTEMP $FILETEMP

SPEEDDOWN=`awk '$0=$2' FS='Download: ' RS='/s' $FILETEMP`
SPEEDUP=`awk '$0=$2' FS='Upload: ' RS='/s' $FILETEMP`

}


function pushbullet {

  API="Your_Pushbullet_API_here"
  MSG="My ISP speed sucks now! Download: $SPEEDDOWN Mbit/s / Upload: $SPEEDUP Mbit/s"
  curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="ALERT - ISP" -d body="$MSG"

}


function deletecreate {
  
  rm $DIRDEST/Download*
  touch $DIRTW/"Download $SPEEDDOWN - Upload $SPEEDUP"

}

copy
pushbullet
deletecreate
