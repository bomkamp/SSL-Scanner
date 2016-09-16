#!/bin/bash

#This script will scan the 112,114,115 subnets for all certificates and grab the following information from them: hostname,issued to, issued by, valid from, valid to.
#@arguments: NONE
#@output: certScan.txt
#@author: Greg Bomkamp (The Ohio State University)

#Overwrite previous certificate file.
printf "CSE SSL Certificate Information - `date +%c`\n\t\tHostname\t\t\tIP address\t\t\tIssued to\t\t\t\tIssued by\t\t\t\tValid from\t\t\t\tValid to\n\t\t%8s\t\t\t%8s\t\t\t%10s\t\t\t\t%10s\t\t\t\t%10s\t\t\t\t%10s\n" '--------' '------------' '----------' '----------' '----------' '----------' > certScan.txt

#Begin by looping through individual subnets
for subnet in 112 114 115  
do
	echo "Now checking $subnet subnet for certificates."
	for host in `seq 1 254`
	do
		#get full ip address of each host
		host=164.107.$subnet.$host
		#attempt to get certificates, if it takes longer than 1s it will timeout and that implies there is none.
		timeout 1s openssl s_client -connect $host:443 2>/dev/null | openssl x509 -noout -dates -issuer -subject > currentSSL.txt
		#if a certificate is returned, there WILL be a subject line, if there is none, subject line will not exist
		if [ `grep -c 'subject' currentSSL.txt` -gt 0 ]
		then 
			#get all relevant info and print to certScan.txt
			hostnm=`dig +short -x $host | sed 's/.$//'`
			issueTo=`cat currentSSL.txt | sed -n "s/^subject.*CN=\([-0-9a-zA-Z\._ ]*\).*$/\1/p"`
			issueBy=`cat currentSSL.txt | sed -n "s/^issuer.*[CN|OU]=\([-0-9a-zA-Z\._ ]*\).*$/\1/p"`
			validFrom=`cat currentSSL.txt | sed -n "s/^notBefore=\(.*$\)/\1/p"`
			expires=`cat currentSSL.txt | sed -n "s/^notAfter=\(.*$\)/\1/p"`
			
			printf "%36s\t%18s\t%26s\t%34s\t%34s\t%34s\n" "$hostnm" "$host" "$issueTo" "$issueBy" "$validFrom" "$expires" >> certScan.txt
		else
			#no subject line therefore no SSL certificates, continue to next host
			echo "No certificate available for $host"
			continue
		fi
	done
done
rm currentSSL.txt
echo "Script Successfully Terminated."

