#!/bin/bash

fuzzing()
{
printf "Dirsearch is started"

cd ${givenPath} && mkdir dirsearch && cd dirsearch

python3 ~/Tools/arsenal/dirsearch/dirsearch.py -e php,asp,aspx,jsp,py,txt,conf,config,bak,backup,swp,old,db,sqlasp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip -l ${givenPath}/httpx/httpx.txt -i 200 --full-url -b ${Domain} -o dir_Result_${Domain} --format=json

printf "Completed with Fuzzing" | notify --silent

}
