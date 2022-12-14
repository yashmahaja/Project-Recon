#!/bin/bash

nucleii()
{
printf "Running Nuclei on $DOMAIN" | notify --silent

printf "Updating templates :D" | notify --silent
nuclei --update-templates --silent
printf "Templates are updated... Let's go..." | notify --silent

cd ${givenPath} && mkdir nuclei && cd nuclei && mkdir output

printf "Scan for CVES started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/cves/ -o output/cves.txt
printf "Scan for cves competed\n" | notify --silent
wc -l output/cves.txt | awk '{print $1 " cves are founded by nuclei"}' | notify --silent

printf "Scan for defualt login started"\n | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/defualt-logins/ -o output/defualt-logins.txt
printf "Scan for defualt login completed\n" | notify --silent
wc -l output/defualt-logins.txt | awk '{print $1 " defualt-logins are founded by nuclei"}' | notify --silent

printf "Scan for Exposures started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/exposures/ -o output/exposures.txt
printf "Scan for Exposures completed\n" | notify --silent
wc -l output/exposures.txt | awk '{print $1 " exposures are founded by nuclei"}' | notify --silent

printf "Scan for Misconfiguration started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/misconfiguration/ -o output/misconfiguration.txt
printf "scan for misconfiguration completed\n" | notify --silent
wc -l output/misconfiguration.txt | awk '{print $1 " misconfiguration are founded by nuclei"}' | notify --silent

printf "Scan for Takeover started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/takeovers/ -o output/takeover.txt
printf "Scan for Takeover completed\n" | notify --silent
wc -l output/takeover.txt | awk '{print $1 " takeover are founded by nuclei"}' | notify --silent

printf "Scan for vulnerablity started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/vulnerabilies/ -o output/vulnerabilies.txt 
printf "Scan for vulnerablity completed\n" | notify --silent
wc -l output/vulnerabilies | awk '{print $1 " vulnerabilies are founded by nuclei"}' | notify --silent

printf "Scan for exposed-panels started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/exposed-panels/ -o output/exposed-panels.txt 
printf "Scan for exposed-panels completed\n" | notify --silent
wc -l output/exposed-panels.txt  | awk '{print $1 " exposed-panels are founded by nuclei"}' | notify --silent

printf "Scan for headless started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/headless/ -o output/headless.txt 
printf "Scan for headless completed\n" | notify --silent
wc -l output/headless.txt | awk '{print $1 " headless are founded by nuclei"}' | notify --silent

printf "Scan for workflows started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/workflows/ -o output/workflows.txt 
printf "Scan for workflows completed\n" | notify --silent
wc -l output/workflows.txt | awk '{print $1 " workflows are founded by nuclei"}' | notify --silent

printf "Scan for cnvd started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/cnvd/ -o output/cnvd.txt 
printf "Scan for cnvd completed\n" | notify --silent
wc -l output/cnvd.txt  | awk '{print $1 " cnvd  are founded by nuclei"}' | notify --silent

printf "Scan for technologies started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/technologies/ -o output/technologies.txt 
printf "Scan for technologies completed\n" | notify --silent
wc -l output/technologies.txt | awk '{print $1 " technologies are founded by nuclei"}' | notify --silent

printf "Scan for fuzzing started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/fuzzing/ -o output/fuzzing.txt 
printf "Scan for fuzzing completed\n" | notify --silent
wc -l output/fuzzing.txt | awk '{print $1 " fuzzing are founded by nuclei"}' | notify --silent

printf "Scan for network started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/network/ -o output/network.txt 
printf "Scan for network completed\n" | notify --silent
wc -l output/network.txt | awk '{print $1 " network are founded by nuclei"}' | notify --silent

printf "Scan for dns started\n" | notify --silent
nuclei -l ${givenPath}/httpx/httpx.txt -silent -t ${HOME}/nuclei-templates/dns/ -o output/dns.txt 
printf "Scan for dns completed\n" | notify --silent
wc -l output/dns.txt | awk '{print $1 " dns are founded by nuclei"}' | notify --silent

printf "\nScan is completed" | notify --silent

}
