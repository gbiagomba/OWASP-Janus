package main

import (
	"bufio"
	"crypto/tls"
	"net/http"
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	// Initialiing http methods
	httpMethods := []string{"ACL", "BASELINE-CONTROL", "BCOPY", "BDELETE", "BMOVE", "BPROPFIND", "BPROPPATCH", "CHECKIN", "CHECKOUT", "CONNECT", "COPY", "DEBUG", "DELETE", "GET", "HEAD", "INDEX", "LABEL", "LOCK", "MERGE", "MKACTIVITY", "MKCOL", "MKWORKSPACE", "MOVE", "NOTIFY", "OPTIONS", "ORDERPATCH", "PATCH", "POLL", "POST", "PROPFIND", "PROPPATCH", "PUT", "REPORT", "RPC_IN_DATA", "RPC_OUT_DATA", "SEARCH", "SUBSCRIBE", "TRACE", "UNCHECKOUT", "UNLOCK", "UNSUBSCRIBE", "UPDATE", "VERSION-CONTROL", "X-MS-ENUMATTS"}

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		url := scanner.Text()

		for _, method := range httpMethods {
			// Generated by curl-to-Go: https://mholt.github.io/curl-to-go
			// curl -k -L -s -x ACL https://example.com
			// TODO: This is insecure; use only in dev environments.
			tr := &http.Transport{
				TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
			}
			client := &http.Client{Transport: tr}

			req, err := http.NewRequest(method, url, nil)
			if err != nil {
				// handle err
			}

			resp, err := client.Do(req)
			if err != nil {
				// handle err
			}
			defer resp.Body.Close()

		}
	}
	if err := scanner.Err(); err != nil {
		log.Print(err)
	}

	// UNIX Time is faster and smaller than most timestamps
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Print("hello world")
}

// Output: {"time":1516134303,"level":"debug","message":"hello world"}
