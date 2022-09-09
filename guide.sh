#!/bin/bash

helps()
{

help="Usage :

  -s To enumerate only subdomains
  -m Medium level Scan (subdomainEnumeration, collectingUrls, nucleiScanning)
  -a Just dirsearch and xss scanning added to the medium
"

printf "$help"

}