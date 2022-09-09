#!/bin/bash

source  ./guide.sh
source ./domain.sh
source ./collecturls.sh
source ./xss.sh
source ./resolve.sh
source ./nuclei.sh
source ./probe.sh
source ./dirsearch.sh


logo(){
bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
orange="\e[33m"
white="\e[37m"
green="\e[32m"
blue="\e[34m"
end="\e[0m"

dir=~/Tools
echo '						 ';
echo -e "$orange ____  _____ ____ ___  _   _ $end";
echo -e "$orange|  _ \| ____/ ___/ _ \| \ | |$end";
echo -e "$white| |_) |  _|| |  | | | |  \| |$end";
echo -e "$white|  _ <| |__| |__| |_| | |\  |$end";
echo -e "$green|_| \_\_____\____\___/|_| \_|$end";
echo -e "$green                              $end";
echo -e "$red $bold Automated with <3 by The Biest $end";


}

logo

while getopts ":smah" arg; do
  case "$arg" in
          s )
            input
            subdomain_Enumeration
            printf "Work is completed" | notify --silent
            ;;
          m )
            input
            subdomain_Enumeration
            findingurls
            probe
            nucleii
            printf "Work is completed for $Domain" | notify --silent
            ;;
          a )
            input
	    subdomain_Enumeration
            findingurls
            probe
            nucleii
            fuzzing
            xsshunter	
            printf "Finished $Domain" | notify --silent
          ;;
          \? | h )
            helps
          ;;
          * )
            echo "Invalid Argument";
          ;;
   esac
done
shift $((OPTIND -1))
