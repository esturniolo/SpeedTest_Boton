#!/bin/bash

API="Your_Pushbullet_API_here"
MSG="Problemas de velocidad de bajada con mi ISP"

curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="ALERTA - ISP" -d body="$MSG"
