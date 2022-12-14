#!/bin/bash

subdomain_Enumeration()
{
cd ${givenPath}
mkdir subdomains
cd subdomains

sleep 2
printf "\nCollecting DNS_Resolvers" | notify --silent
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 500 -o resolvers.txt

printf "\nStarting Subdomain Enumeration" | notify --silent

printf "Running Subfinder\n" | notify --silent
subfinder -d $Domain -all -recursive --silent -config $HOME/.config/subfinder/config.yaml -o subfinder.txt
cat subfinder.txt | anew | tee -a allsubs1.txt
wc -l allsubs1.txt | awk '{print $1 " subdomains founded by Subfinder"}' | notify --silent

printf "Running CRT.sh\n" | notify --silent
python3 $HOME/tools/ctfr/ctfr.py -d $Domain -o crt.txt
cat crt.txt | anew | tee -a allsubs2.txt
wc -l allsubs2.txt | awk '{print $1 " subdomains founded by CRT.sh"}' | notify --silent

printf "Running AssetFinder\n" | notify --silent
assetfinder $Domain | anew allsubs3.txt
wc -l allsubs3.txt | awk '{print $1 " subdomains founded by AssetFinder"}' | notify --silent

printf "Running Finddomain\n" | notify --silent
findomain -t $Domain -u finddomain.txt
cat finddomain.txt | anew | tee -a allsubs4.txt
wc -l allsubs4.txt | awk '{print $1 " subdomains founded by Finddomain"}' | notify --silent

printf "Running sd-goo.sh (Domains from google search)\n" | notify --silent
sd-goo.sh $Domain | anew allsubs5.txt
wc -l allsubs5.txt | awk '{print $1 " subdomains founded by sd-goo.sh"}' | notify --silent

printf "Running Shodan\n" | notify --silent
shodan_dorks=(ssl.cert.subject.cn:$Domain hostname:$Domain org:$Domain)
for i in "${shodan_dorks[@]}"; do
	shodan search "$i" --fields ip_str,port --separator " " | awk '{print $1":"$2}' >>shodan_${Domain}_ips.txt
	cat shodan_${Domain}_ips.txt | awk -F ':' '{print $1}' | dnsx -ptr -resp-only >>shodan_subs.txt
done
cat shodan_subs.txt | anew | tee -a allsubs6.txt
wc -l allsubs6.txt | awk '{print $1 " subdomains founded by Shodan"}'  | notify --silent

printf "Running Amass" | notify --silent
timeout 30m amass enum -passive -d $Domain -config $HOME/.config/amass/config.ini -o amass.txt
cat amass.txt | anew | tee -a allsubs7.txt
wc -l allsubs7.txt | awk '{print $1 " subdomains founded by Amass"}'  | notify --silent

printf "Running gauplus\n" | notify --silent
gauplus -t 15 -random-agent -subs $Domain | unfurl -u domains | anew allsubs8.txt
wc -l allsubs8.txt | awk '{print $1 " subdomains founded by gauplus"}'  | notify --silent

printf "Running Waybackurls\n" | notify --silent
waybackurls $Domain | unfurl -u domains | anew allsubs9.txt
wc -l allsubs9.txt | awk '{print $1 " subdomains founded by Waybackurls"}' | notify --silent

printf "Running Github-subdomains\n" | notify --silent
github-subdomains -d $Domain -t $HOME/.config/github-subdomains/tokens.txt -o github-subdomains.txt
cat github-subdomains.txt | anew | tee -a allsubs10.txt
wc -l allsubs10.txt | awk '{print $1 " subdomains founded by Github-subdomains"}'  | notify --silent

printf "Running crobat\n" | notify --silent
crobat -s $Domain | anew allsubs11.txt
wc -l allsubs11.txt | awk '{print $1 " subdomains founded by crobat"}' | notify --silent

printf "Running tls.bufferover\n" | notify --silent
curl "https://tls.bufferover.run/dns?q=$Domain" | jq -r .Results'[]' | rev | cut -d ',' -f1 | rev | sort -u | grep "\.$Domain" | anew allsubs12.txt
wc -l allsubs12.txt | awk '{print $1 " subdomains founded by tls.bufferover"}' | notify --silent

printf "Running dns.bufferover\n" | notify --silent
curl "https://dns.bufferover.run/dns?q=$Domain" | jq -r .FDNS_A'[]',.RDNS'[]' | cut -d ',' -f2 | grep "\.$Domain" | anew allsubs13.txt
wc -l allsubs13.txt | awk '{print $1 " subdomains founded by dns.bufferover"}' | notify --silent

sleep 2
printf "Running Puredns\n" | notify --silent
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 500 -o resolvers.txt
puredns bruteforce $HOME/wordlist/best-dns-wordlist.txt $Domain -r resolvers.txt -w puredns_bruteforce.txt --wildcard-batch 1000000
cat puredns_bruteforce.txt | anew | tee -a allsubs14.txt
wc -l allsubs14.txt | awk '{print $1 " subdomains founded by Puredns"}' | notify --silent

printf "Sorting Colleted Subdomains\n" | notify --silent
cat allsubs*.txt | anew subdomains.txt
wc -l subdomains.txt | awk '{print $1 " subdomains are founded till now"}' | notify --silent

printf "Running DNSCewl\n" | notify --silent
DNScewl --tL subdomains.txt -p $HOME/wordlist/permutations_list.txt --level=0 --subs --no-color | tail -n +14 >permutations.txt
printf "Running Puredns for resolving permutation subdomains\n"  | notify --silent
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 500 -o resolvers.txt
puredns resolve permutations.txt -r resolvers.txt --wildcard-batch 1000000 -w puredns_permutation.txt
cat puredns_permutation.txt | grep "\.${Domain}" | anew | tee -a allsubs15.txt
wc -l allsubs15.txt | awk '{print $1 " subdomains founded by DNScewl and Puredns"}' | notify --silent
rm permutations.txt
cat allsubs15.txt | anew subdomains.txt

printf "Scraping Subdomains from JS/Source code\n" | notify --silent
cat subdomains.txt | httpx -random-agent -retries 2 -no-color -o probed_tmp_scrap.txt
timeout 20m gospider -S probed_tmp_scrap.txt --js -t 50 -d 3 --sitemap --robots -w -r | tee gospider.txt
sed -i '/^.\{2048\}./d' gospider.txt
cat gospider.txt | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains | grep "\.${DOMAIN}" | anew allsubs16.txt
wc -l allsubs16.txt | awk '{print $1 " subdomains  founded from JS/Source code"}' | notify --silent
rm gospider.txt
cat allsubs16.txt | anew subdomains.txt

wc -l subdomains.txt | awk '{print $1 " are total subdomains founded by Project Morya"}' | notify --silent
cat subdomains.txt | grep "\.${Domain}" | tee actual_Subdomains.txt

printf "Probing on common ports \n" | notify --silent
COMMON_PORTS_WEB="81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7396,7474,8000,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8834,8880,8888,8983,9000,9001,9043,9060,9080,9090,9091,9200,9443,9502,9800,9981,10000,10250,11371,12443,15672,16080,17778,18091,18092,20720,32000,55440,55672"
sudo unimap --fast-scan -f actual_Subdomains.txt --ports $COMMON_PORTS_WEB -q -k --url-output | tee unimap_commonweb.txt
cat unimap_commonweb.txt | httpx -random-agent -status-code -silent -retries 2 -no-color | cut -d ' ' -f1 | anew allsubs17.txt
wc -l allsubs17.txt | awk '{print $1 " are domains subdomains founded by unimap"}'  | notify --silent
cat allsubs17.txt | anew actual_Subdomains.txt
#subdomain_path=`pwd`/actual_Subdomains.txt

wc -l actual_Subdomains.txt | awk '{print $1 " are total actual subdomains founded by Project Morya"}'  | notify --silent

mkdir trash
mv allsub* trash/
mv gsd* trash/
sudo mv unimap_logs/ trash/
mv amass.txt trash/
mv resolvers.txt subfinder.txt crt.txt assetFinder.txt finddomain.txt shodan_subs.txt shodan_${DOMAIN}_ips.txt github-subdomains.txt puredns_bruteforce.txt puredns_permutation.txt probed_tmp_scrap.txt unimap_commonweb.txt resume.cfg trash/

printf "\nSubdomain Enumeration Completed" | notify --silent
}
