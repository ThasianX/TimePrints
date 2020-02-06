#!/usr/bin/env bash

set -e
set -o pipefail

file_path="build/namespace/mapbox-events-ios-static/libMapboxEvents.a"
file_size=$(wc -c <"$file_path" | sed -e 's/^[[:space:]]*//')
date=`date '+%Y-%m-%d'`
utc_iso_date=`date -u +'%Y-%m-%dT%H:%M:%SZ'`
label="Telemetry Static"
source="mobile.binarysize"
scripts_path="scripts"
json_name="$scripts_path/ios-binarysize.json"
json_gz="$scripts_path/ios-binarysize.json.gz"

# Publish to github
"$scripts_path"/publish_to_sizechecker.js "$file_size" "$label"

# Write binary size to json file
cat >"$json_name" <<EOL
{"sdk": "telemetry", "platform": "ios", "size": ${file_size}, "created_at": "${utc_iso_date}"}
EOL

# Compress json file
gzip -f "$json_name" > "$json_gz" 

# Set env variables before the next step
envman add --key AWS_SOURCE --value "$source"
envman add --key AWS_PARTITION --value "$date"
envman add --key LOCAL_PATH --value "$json_gz"