#!/usr/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)
# Fork of https://github.com/gbiagomba/OWASP-Janus

if [ -z $1 ]; then
	echo "You did not specify a target (e.g., www.example.com)"
	exit
fi

{
for webservmethod in ACL BASELINE-CONTROL BCOPY BDELETE BMOVE BPROPFIND BPROPPATCH CHECKIN CHECKOUT CONNECT COPY DEBUG DELETE GET HEAD INDEX LABEL LOCK MERGE MKACTIVITY MKCOL MKWORKSPACE MOVE NOTIFY OPTIONS ORDERPATCH PATCH POLL POST PROPFIND PROPPATCH PUT REPORT RPC_IN_DATA RPC_OUT_DATA SEARCH SUBSCRIBE TRACE UNCHECKOUT UNLOCK UNSUBSCRIBE UPDATE VERSION-CONTROL X-MS-ENUMATTS; do
	echo "---------------------------------------------------------------------------------"
	printf "Host: $1 \n"
	printf "Testing HTTP $webservmethod Request: \n"
	echo "---------------------------------------------------------------------------------"
	# curl -kL -X $webservmethod -d '<script>alert('document.cookie')</script>' $1
	curl -IkLs --max-time 3 -X $webservmethod $1
	echo
done
} | tee -a janus_output-$(date +%m-%d-%Y).txt
