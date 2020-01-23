#!/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)

for webservmethod in GET POST PUT TRACE CONNECT OPTIONS PROPFIND DELETE HEAD PATCH; do
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	printf "Host: $1 \n" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	printf "Testing HTTP $webservmethod Request: \n" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	# curl -kL -X $webservmethod -d '<script>alert('document.cookie')</script>' $1
	curl -kLs -X $webservmethod $1 | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo | tee -a $(date +%m-%d-%Y)-janus_output.txt
done
