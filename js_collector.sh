#!/usr/bin/env bash

if [ $# -ne 1 ]
then
        echo "Target not specified."
        echo "Usage: ./gather_urls.sh <domain>"
        exit 1
fi

echo "=========================================================="
echo "[*] Script to collect all Javascript files in one place..."
echo "=========================================================="
echo ""

host_base=~/hosts/$1
http_base=${host_base}/http
urls_base=${http_base}/urls
http_alive=${host_base}/subdomains/http_alive.txt

echo "[*] Running getJS to gather Javascript files..."
getJS -complete -input=${http_alive} -verbose -output=${urls_base}/getjs_out.txt
echo "[*] getJS Complete..."
echo ""

echo "[*] Running subjs to gather Javascript files..."
subjs -c 25 -i ${http_alive} | grep "$1" | tee ${urls_base}/subjs_out.txt
echo "[*] subjs Complete..."
echo ""

echo "[*] Gathering all alive Javascript files in http/all_alive_js.txt..."
cat ${urls_base}/getjs_out.txt ${urls_base}/subjs_out.txt | cut -d'?' -f1 | sort -u > ${urls_base}/js_tools_out.txt
cat ${urls_base}/live_urls.txt | cut -d'?' -f1 | egrep "\.js$" | sort -u > ${urls_base}/spiders_js_out.txt
rm ${urls_base}/getjs_out.txt ${urls_base}/subjs_out.txt

cat ${urls_base}/js_tools_out.txt ${urls_base}/spiders_js_out.txt | anew ${http_base}/all_alive_js.txt > /dev/null
rm ${urls_base}/spiders_js_out.txt
echo "[*] all_alive_js.txt created successfully..."

echo "[*] Downloading all those Javascript files..."
# nc/no-clobber with wget will prevent the duplication of files in the directory..
cat alive_js.txt | parallel -j 35 wget -nc {} --directory-prefix ${http_base}/js_files/
echo "[*] Files downloaded in http/js_files/."
echo ""

echo "./js_collector.sh Complete..."
echo "[*] Now you can manually check the JS files or automate it using different tools. ;)"
