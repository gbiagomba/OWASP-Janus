#!/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)
# Fork of https://github.com/gbiagomba/OWASP-Janus

for webservmethod in ACL BASELINE-CONTROL BCOPY BDELETE BMOVE BPROPFIND BPROPPATCH CHECKIN CHECKOUT CONNECT COPY DEBUG DELETE GET HEAD INDEX LABEL LOCK MERGE MKACTIVITY MKCOL MKWORKSPACE MOVE NOTIFY OPTIONS ORDERPATCH PATCH POLL POST PROPFIND PROPPATCH PUT REPORT RPC_IN_DATA RPC_OUT_DATA SEARCH SUBSCRIBE TRACE UNCHECKOUT UNLOCK UNSUBSCRIBE UPDATE VERSION-CONTROL X-MS-ENUMATTS; do
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	printf "Host: $1 \n" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	printf "Testing HTTP $webservmethod Request: \n" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	# curl -kL -X $webservmethod -d '<script>alert('document.cookie')</script>' $1
	curl -kLs --max-time 10 -X $webservmethod $1 | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo "---------------------------------------------------------------------------------" | tee -a $(date +%m-%d-%Y)-janus_output.txt
	echo | tee -a $(date +%m-%d-%Y)-janus_output.txt
done
