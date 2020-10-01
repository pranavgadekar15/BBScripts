#!/bin/sh
filename=$1
while read url; do
        echo "Nuclei Started"
        nuclei -l $url.txt  -t dns/ -t generic-detection/ -t panels/ -t payloads/ -t security-misconfiguration/ -t subdomain-takeover/ -t technologies/ -t tokens/ -t vulnerabilities/ -t workflows/  -t cves/ -t files/ -t /default-credentials -o $url_nuceli.txt
done < $filename
