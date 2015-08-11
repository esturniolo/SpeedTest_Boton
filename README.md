# SpeedTest Boton

You can check your internet connection manually or using cron.
The best way to schedule it is every 30 minutes
E.g: 0,30 * * * * script

The script made a png image made with "gnuplot" (You need to cron a "mv" command at midnigth to move the image, so you'll have only one image by day).

Capabilities:
.If the download is below 25 Mbit/s (editable in speedtest_boton.sh, function pushbullet), the script send a Pushbullet notification with the error.
.If you use IFTTT, you can use this recipe "https://ifttt.com/recipes/315452-speedtest-boton-isp-reporter" to report the speed issue to your ISP provider.

Requirements:
speedtest-cli
gnuplot
curl

Optional:
Pushbullet account (so you can add your API key)
IFTTT account (to send a tweet reporting the issue)
Dropbox account (to place the file that uses IFTTT to send the tweet)

Enjoy it!
