#!/bin/bash

DIAHOY=`date +%d-%m-%Y`
AHORA=`date +%A %d-%m-%Y %H:%M`
HORA=`date +%H:%M`
DIRTEMP=/go/to/temp/dir
FILETEMP=test_temp.tmp
BAJADAAWK=`awk '$0=$2' FS='Download: ' RS='.' $DIRTEMP/$FILETEMP`
SUBIDAAWK=`awk '$0=$2' FS='Upload: ' RS='.' $DIRTEMP/$FILETEMP`
BAJADAPLOT=`awk '$0=$2' FS='Download: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`
SUBIDAPLOT=`awk '$0=$2' FS='Upload: ' RS='Mbit/s' $DIRTEMP/$FILETEMP`
PLOT=`echo $HORA" "$BAJADAPLOT" "$SUBIDAPLOT >> $DIRTEMP/plot.dat`
DIRDEST=/go/to/destination/dir
DIRSCRIPTS=/dir/where/are/the/scripts

function pushbullet {

if (("$BAJADAAWK" < "25")); then
	`bash $DIRSCRIPTS/pbbad.sh > /dev/null`;
	else
	`bash $DIRSCRIPTS/pbok.sh > /dev/null`
fi

}

function speedtest {

speedtest-cli --simple > $DIRTEMP/$FILETEMP

}

function grabar_datos {

echo >> $DIRDEST/$DIAHOY.log
echo "**********************************" >> $DIRDEST/$DIAHOY.log 
echo "****" $AHORA "****" >> $DIRDEST/$DIAHOY.log
cat $DIRTEMP/$FILETEMP >> $DIRDEST/$DIAHOY.log 
echo "**********************************" >> $DIRDEST/$DIAHOY.log 
echo >> $DIRDEST/$DIAHOY.log
echo '----------------------------------' >> $DIRDEST/$DIAHOY.log
echo >> $DIRDEST/$DIAHOY.log
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
	plot '/tmp/plot.dat' using 1:2 with linespoints title 'Bajada', '/tmp/plot.dat' using 1:3 with linespoints title 'Subida'
EOF
}

speedtest
grabar_datos
pushbullet
plot
