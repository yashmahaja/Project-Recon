#!/bin/bash

findingurls()

{
    printf "Collecting waybackurls" 

    cd ${givenPath}
    mkdir wayback
    cd wayback
    
    printf "Running waybackurls" | notify --silent
    cat ${givenPath}/subdomains/subdomains.txt | waybackurls | anew wayback.txt
    wc -l wayback.txt | awk '{print $1 " Wayback Archives"}' 
    
    printf "Running gauplus" | notify --silent
    cat ${givenPath}/subdomains/subdomains.txt | gauplus | tee gau.txt
    wc -l gau.txt | awk '{print $1 " GauPlus"}' 

    cat wayback.txt gau.txt | sort -u | tee urls.txt
    wc -l urls.txt | awk '{print $1 " Sorting the urls"}'
    
    printf "All urls are here!!" | notify --silent
}
