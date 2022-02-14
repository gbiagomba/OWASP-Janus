#!/usr/bin/env bash
# Reference: https://www.owasp.org/index.php/Testing_for_HTTP_Verb_Tampering_(OTG-INPVAL-003)
# reference for parallel: https://stackoverflow.com/questions/23814360/gnu-parallel-and-bash-functions-how-to-run-the-simple-example-from-the-manual

if ! hash curl 2> /dev/null; then
	echo "Please install curl - https://curl.se/download.html & try again"
	exit
fi

# initiallizing variables
current_time=$(date "+%Y.%m.%d-%H.%M.%S.%N")
outputfile="$PWD/janus_output-$current_time"
curl_cmd="curl -IkLs --max-time 3 -X"
declare -i min=0
declare -i c=10

# Menu & flags
while [ ! $# -eq 0 ]; do
	case "$1" in
		--help | -h | \?)
			echo
			echo "Usage:"
			echo "-h, --help               show brief help"
			echo "-iL, --target-file       specify the target list"
			echo "-m, --http-method        specify the http request method you want to use (default: 27 methods are checked)"
			echo "-o, --output             specify the output file (default: stdout)"
			echo "-t, --threads            specify the number of threads when evoking targetfile (default 10)"
			echo "-u, --url-target         specify the url (http://www.example.com)"
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
fi

if [ -z $url ] && [ ! -e $targetfile ]; then
	echo "You provided an empty URL, please provide a valid URL (example: janus -u http://www.example.com)"; exit
fi

if [ -z $httpMethods ]; then
	httpMethods=(ACL BASELINE-CONTROL BCOPY BDELETE BMOVE BPROPFIND BPROPPATCH CHECKIN CHECKOUT CONNECT COPY DEBUG DELETE GET HEAD INDEX LABEL LOCK MERGE MKACTIVITY MKCOL MKWORKSPACE MOVE NOTIFY OPTIONS ORDERPATCH PATCH POLL POST PROPFIND PROPPATCH PUT REPORT RPC_IN_DATA RPC_OUT_DATA SEARCH SUBSCRIBE TRACE UNCHECKOUT UNLOCK UNSUBSCRIBE UPDATE VERSION-CONTROL X-MS-ENUMATTS)
fi

if [ -z $outputfile ]; then
	outputfile="$PWD/janus_output-$current_time.txt"
fi

if [ ! $c gt 0 ]; then
	echo "You need to set the threats to be greater then 0"
	exit
fi

# Functions
function main
{
	local local_url=$1
	for webservmethod in ${httpMethods[*]}; do
	    if [ -x screen ] || hash screen 2>/dev/null; then
			echo "Using screen to scan $local_url"
			screen -dmS $RANDOM bash -c "printf "HTTP $webservmethod Request Method - $local_url - $($curl_cmd $webservmethod $local_url | grep -i "HTTP/" | tr "\n" " ")" | tee -a $outputfile.log"
		elif [ -x tmux ] || hash tmux 2>/dev/null; then
			echo "Using tmux to scan $local_url"
			tmux new -d -s $RANDOM
			tmux send-keys -t $(tmux ls | cut -d ":" -f 1 | sort -fnru | tail -n 1).0 "printf "HTTP $webservmethod Request Method - $local_url - $($curl_cmd $webservmethod $local_url | grep -i "HTTP/" | tr "\n" " ")"" ENTER
		fi
		echo
	done
}

# Launching main
{
	if [ ! -z $url ]; then
		main $url
	elif [ ! -z $targetfile ]; then
		for i in `cat $targetfile`; do
			while [ $(pgrep -x curl -u $(id -u $USERNAME) | wc -l) -ge $c ]; do sleep 10; done
			main $i
		done
	fi
} | tee $outputfile.out

# Combining output & generating cvs
echo "http_verb,url,proto_version,status_code,status_response" >> $outputfile.csv
cat $outputfile.out | cut -d " " -f 3,7,9-25 | sort -u | tr " " "," >> $outputfile.csv
