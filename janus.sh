#!/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)

for webservmethod in GET POST PUT TRACE CONNECT OPTIONS PROPFIND DELETE HEAD PATCH; do
	echo "---------------------------------------------------------------------------------"
	printf "Host: $1 \n"
	printf "Testing HTTP $webservmethod Request: \n"
	echo "---------------------------------------------------------------------------------"
	# curl -kL -X $webservmethod -d '<script>alert('document.cookie')</script>' $1
	curl -kL -X $webservmethod $1
	echo "---------------------------------------------------------------------------------"
	echo
done
