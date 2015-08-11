#!/bin/bash

#Speedtest Boton made by Emiliano Sturniolo <esturniolo@gmail.com>
#Use it as you want, be happy. Just remember me in every run :D

TODAY=`date +%d-%m-%Y`
NOW=`date +%A %d-%m-%Y %H:%M`
TIME=`date +%H:%M`
DIRTEMP=/go/to/temp/dir
FILETEMP=test_temp.tmp
DOWNLOADAWK=`awk '$0=$2' FS='Download: ' RS='.' $DIRTEMP/$FILETEMP`
UPLOADAWK=`awk '$0=$2' FS='Upload: ' RS='.' $DIRTEMP/$FILETEMP`
DOWNLOADPLOT=`awk '$0=$2' FS='Download: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`
UPLOADPLOT=`awk '$0=$2' FS='Upload: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`
PLOT=`echo $TIME" "$DOWNLOADPLOT" "$UPLOADPLOT >> $DIRTEMP/plot.dat`
DIRDEST=/go/to/destination/dir
DIRSCRIPTS=/dir/where/are/the/scripts

function pushbullet {

if (("$DOWNLOADAWK" < "25")); then
	`bash $DIRSCRIPTS/pbbad.sh > /dev/null`;
	else
	`bash $DIRSCRIPTS/pbok.sh > /dev/null`
fi

}

function speedtest {

speedtest-cli --simple > $DIRTEMP/$FILETEMP #You can specify the server with --server

}

function grabar_datos {

echo >> $DIRDEST/$TODAY.log
echo "**********************************" >> $DIRDEST/$TODAY.log 
echo "****" $NOW "****" >> $DIRDEST/$TODAY.log
cat $DIRTEMP/$FILETEMP >> $DIRDEST/$TODAY.log 
echo "**********************************" >> $DIRDEST/$TODAY.log 
echo >> $DIRDEST/$TODAY.log
echo '----------------------------------' >> $DIRDEST/$TODAY.log
echo >> $DIRDEST/$TODAY.log
}

function plot {

gnuplot <<- EOF
	set xdata time
	set timefmt '%H:%M'
	set grid
	set yrange [0:50]
	set xlabel 'Hora del test'
	set ylabel 'Velocidad (Mbits/s)'
	set terminal png size 1024,768 enhanced font "Verdana,10"
	set output '/dir/to/store/output/output.png'
	plot '/tmp/plot.dat' using 1:2 with linespoints title 'Download', '/tmp/plot.dat' using 1:3 with linespoints title 'Upload'
EOF
}

speedtest
grabar_datos
pushbullet
plot
