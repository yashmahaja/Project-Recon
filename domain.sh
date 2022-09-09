#!/bin/bash

input()
{

printf "\n\n"
printf "\nPlease Enter a Domain : "
read Domain
export Domain=$Domain
validate="$(python3 \
  validatedomain.py)"

if [ $validate -eq 1 ]
then 
  printf "\nProject Recon started" | notify --silent

  printf "Domain provide to us: $Domain\n" | notify --silent
  TODAY=`date '+%d/%b/%y %r'`
  sleep 2
  printf "Scanning is started at ${TODAY}" | notify --silent
  printf "Creating directory ${Domain}_recon\n" | notify --silent

  Directory="${Domain}_recon"
  mkdir $Directory
  cd $Directory
  mkdir vulnerability
  RUNNING_PATH=`pwd`
  
else 
  printf "\nPlease enter valid domain"
  printf "\nExample : abc.com\n"
  exit 1
fi

}
