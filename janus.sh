#!/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)

for webservmethod in GET POST PUT TRACE CONNECT OPTIONS PROPFIND; do
	printf "$webservmethod " ;
	printf "$webservmethod / HTTP/1.1\nHost: $1\n\n" | nc -q 1 $1 80 | grep "HTTP/1.1"
	curl -X $webservmethod -d '<IMG SRC="javascript:alert('XSS');">' $1
done
