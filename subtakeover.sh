#!/bin/sh
filename=$1
while read url; do
          echo "Subfinder"
          subfinder -d $url -o $url.txt
          echo "Assetfinder"
          assetfinder -subs-only $url | tee -a $url.txt
          sort -u $url.txt -o $url.txt
          subjack -w $url.txt -o $url_takeover.txt
done < $filename
