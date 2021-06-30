#!/bin/sh

for i in $(seq 0 149)
do
	# get Degenimal name from OpenSea API
	name=$(curl -s "https://api.opensea.io/api/v1/assets?order_direction=desc&collection=degenimals&offset=$i&limit=1"| jq '.assets[].name' | tr -d '"')

	echo -n "Processing Degenimal ($name)... "

	# if assets already exist, skip
	if test -f ./assets/image/$name
	then
		echo "asset exists, skipped"
	else
		echo -n "downloading... "
		wget -q \
		`curl -s "https://api.opensea.io/api/v1/assets?order_direction=desc&collection=degenimals&offset=$i&limit=1" \
		| jq '.assets[].image_url' | tr -d '"'` -O assets/image/$name && echo "done"
	fi

	# sleep to avoid hitting API rate limit
	sleep 1
done
