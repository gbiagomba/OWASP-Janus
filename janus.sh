#!/usr/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)
# reference for parallel: https://stackoverflow.com/questions/23814360/gnu-parallel-and-bash-functions-how-to-run-the-simple-example-from-the-manual

if ! hash curl 2> /dev/null; then
	echo "Please install curl - https://curl.se/download.html & try again"
	exit
fi

# initiallizing variables
outputfile="$PWD/janus_output-$current_time"
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
curl_cmd="curl -IkLs --max-time 3 -X"
tmpdir=`mktemp -d`
declare -i min=0
declare -i c=10

# Menu & flags
while [ ! $# -eq 0 ]; do
	case "$1" in
		--help | -h | \?)
			echo
			echo "Usage:"
			echo "-h, --help                show brief help"
			echo "-iL, --target-file       specify the target list"
			echo "-m, --http-method 	      specify the http request method you want to use (default: 27 methods are checked)"
			echo "-o, --output				      specify the output file (default: stdout)"
			echo "-t, --threads				      specify the number of threads when evoking targetfile (default 10)"
			echo "-u, --url-target		      specify the url (http://www.example.com)"
			echo
			echo "Example:"
			echo "janus -u http://www.example.com"
			echo "janus -iL web_targets.list -o filename.txt"
			exit
			;;
		--target-file | -iL)
			shift
			targetfile=$1
			shift
			;;
		--http-method | -m)
			shift
			httpMethods=($(echo $1 | tr '[:lower:]' '[:upper:]' | tr "," " "))
			shift
			;;
		--output | -o)
			shift
			outputfile=$1
			shift
			;;
		--threads | -t)
			shift
			c=$1
			shift
			;;
		--url-target | -u)
			shift
			url=$1
			shift
			;;
	esac
	shift
done

# Checking if key variables are enabled
if [ ! -e $targetfile ]; then
	echo "$targetfile does not exist, please provide a target list/file"; exit
elif [ -z $url ] && [ ! -e $targetfile ]; then
	echo "You provided an empty URL, please provide a valid URL (example: janus -u http://www.example.com)"; exit
elif [ -z $httpMethods ]; then
	httpMethods=(ACL BASELINE-CONTROL BCOPY BDELETE BMOVE BPROPFIND BPROPPATCH CHECKIN CHECKOUT CONNECT COPY DEBUG DELETE GET HEAD INDEX LABEL LOCK MERGE MKACTIVITY MKCOL MKWORKSPACE MOVE NOTIFY OPTIONS ORDERPATCH PATCH POLL POST PROPFIND PROPPATCH PUT REPORT RPC_IN_DATA RPC_OUT_DATA SEARCH SUBSCRIBE TRACE UNCHECKOUT UNLOCK UNSUBSCRIBE UPDATE VERSION-CONTROL X-MS-ENUMATTS)
elif [ -z $outputfile ]; then
	outputfile="$PWD/janus_output-$current_time.txt"
elif [ ! $c gt 0 ]; then
	echo "You need to set the threats to be greater then 0"
	exit
fi

# Functions
function main
{
	local local_url=$1
	for webservmethod in ${httpMethods[*]}; do
		SiteStatus=$(curl -o /dev/null -k --silent --max-time 3 -X $webservmethod --write-out "%{http_code} $1\n" "$1" | cut -d " " -f 1)
		if [ "$SiteStatus" != "304" ] && [ "$SiteStatus" != "302" ] && [ "$SiteStatus" != "403" ] && [ "$SiteStatus" != "405" ] && [ "$SiteStatus" != "000" ] && [ ! -z $SiteStatus ]; then
			printf " HTTP $webservmethod Request Method - $local_url - $($curl_cmd $webservmethod $local_url | grep -i "HTTP/" | tr "\n" " ")" # | tee -a $tmpdir/`echo $local_url | tr "/" "_" | tr ":" "_"`-janus_output-$current_time.txt
			echo
		fi
	done
}

# Launching main
{
	if [ ! -z $url ]; then
		main $url
	elif [ ! -z $targetfile ]; then
		for i in `cat $targetfile`; do
			 main $i &
			let "min+=1"
			if (( $min == $c ));then
				while pgrep -x curl > /dev/null; do sleep 10; done; min=0
			fi
		done
	fi
} | tee $outputfile.out # $PWD/janus_output-$current_time.txt

# Combining output & generating cvs
# cat  $tmpdir/*.txt | sort -u | tee -a $outputfile.out
# echo "http_verb,url,proto_version,status_code,status_response" >> $outputfile.csv
# cat $outputfile.out | cut -d " " -f 3,7,9-25 | tr " " "," >> $outputfile.csv
