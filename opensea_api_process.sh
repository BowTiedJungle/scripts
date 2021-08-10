#!/bin/sh

mkdir -p assets/image
mkdir -p assets/metadata

for i in $(seq 0 149)
do
        # download Degenimal asset JSON data
        json=$( curl -s "https://api.opensea.io/api/v1/assets?order_direction=desc&collection=degenimals&offset=$i&limit=1" | jq '.' )

        # get Degenimal name
        name=$( jq '.assets[].name' <<< "$json" | tr -d '"' )
        echo "Found Degenimal: ${name}!"

        # if metadata exists, skip
        if test -f ./assets/metadata/$name
        then
                echo "Metadata exists, skipped..."
        else
                echo "$json" > ./assets/metadata/$name.json
                echo "Metadata saved"
        fi

        # if asset image already exist, skip
        if test -f ./assets/image/$name
        then
                echo "Avatar image exists, skipped..."
        else
                wget `jq '.assets[].image_url' ./assets/metadata/$name | tr -d '"'` -O ./assets/image/$name
                echo "Avatar image saved"
        fi

        echo ""
        # sleep to avoid hitting API rate limit
        sleep 2
done
