#!/bin/bash

#Speedtest Boton made by Emiliano Sturniolo <esturniolo@gmail.com>
#Use it as you want, be happy. Just remember me in every run :D

#####
# CHANGE THI VARIABLE
ISPNAME=YOUR_ISP_PROVIDER_NAME
MINDOWNLOADSPEED=500
#
#####

TODAY=$(date +%d-%m-%Y)
NOW=$(date '+%A %d-%m-%Y %H:%M')
TIME=$(date +%H:%M)
PLOTDATADIR=./plot
FILETEMP=test_temp.tmp
DOWNLOADAWK=$(awk '$0=$2' FS='Download: ' RS='.' $PLOTDATADIR/$FILETEMP)
UPLOADAWK=$(awk '$0=$2' FS='Upload: ' RS='.' $PLOTDATADIR/$FILETEMP)
DOWNLOADPLOT=$(awk '$0=$2' FS='Download: ' RS='Mbit/s' $PLOTDATADIR/$FILETEMP)
UPLOADPLOT=$(awk '$0=$2' FS='Upload: ' RS='Mbit/s' $PLOTDATADIR/$FILETEMP)
PLOT=`echo $TIME" "$DOWNLOADPLOT" "$UPLOADPLOT >> $PLOTDATADIR/plot.dat`
DIRDEST=./data
DIRSCRIPTS=.

function createdirs {
	if [ ! -d $DIRDEST ]; then
	    mkdir -p $DIRDEST
	fi

	if [ ! -d $PLOTDATADIR ]; then
	    mkdir -p $PLOTDATADIR
	fi
}

function pushbullet {
	if (("$DOWNLOADAWK" < "$MINDOWNLOADSPEED")); then
		`bash $DIRSCRIPTS/pbbad.sh > /dev/null`;
		else
		`bash $DIRSCRIPTS/pbok.sh > /dev/null`
	fi
}

function speedtest {
    if ! which speedtest-cli > /dev/null; then 
        echo -e "Missing speedtest-cli binary.\nPlease install it using '$ sudo apt-get install speedtest-cli'"
        exit 1
	else
	speedtest-cli --simple > $PLOTDATADIR/$FILETEMP #You can specify the server with --server
    fi
}

function save_data {
	echo >> $DIRDEST/$TODAY.log
	echo "**********************************" >> $DIRDEST/$TODAY.log 
	echo "****" $NOW "****" >> $DIRDEST/$TODAY.log
	cat $PLOTDATADIR/$FILETEMP >> $DIRDEST/$TODAY.log 
	echo "**********************************" >> $DIRDEST/$TODAY.log 
	echo >> $DIRDEST/$TODAY.log
	echo '----------------------------------' >> $DIRDEST/$TODAY.log
	echo >> $DIRDEST/$TODAY.log
}

function plot {
	if ! which gnuplot > /dev/null; then 
        echo -e "Missing gnuplot binary.\nPlease install it using '$ sudo apt-get install gnuplot'"
        exit 1
	else	
		gnuplot <<- EOF
    		set xdata time
    		set timefmt '%H:%M'
    		set grid
    		set autoscale y
    		set xlabel 'Test time'
    		set ylabel 'Speed (Mbits/s)'
    		set terminal png size 1024,768 enhanced font "Verdana,10"
    		set output '${DIRDEST}/${ISPNAME}-speedtest-graph.png'
    		plot '${PLOTDATADIR}/plot.dat' using 1:2 with linespoints title 'Download', '${PLOTDATADIR}/plot.dat' using 1:3 with linespoints title 'Upload'
		EOF
    fi
}

createdirs
speedtest
save_data
#pushbullet
plot
