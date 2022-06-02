/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"io"
	"net/http"

	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

// scanCmd represents the scan command
var scanCmd = &cobra.Command{
	Use:   "scan",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		jsonLogs, _ := cmd.Flags().GetBool("json")
		if jsonLogs {
			log.Logger = jsonLogger
		}

		url, _ := cmd.Flags().GetString("url-target")
		err := scan(url, httpClient)
		if err != nil {
			log.Printf("Scanning encountered an error,%v", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(scanCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// scanCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	scanCmd.Flags().StringP("url-target", "u", "", "Specify the target url (http://www.example.com)")
	scanCmd.MarkFlagRequired("url-target")

	scanCmd.Flags().BoolP("json", "j", false, "Output JSON Results")
}

type scanResult struct {
	StatusCode int
	Body       string
}

func scanSpecific(method string, url string, thisClient *http.Client) (*scanResult, error) {
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return nil, err
	}

	resp, err := thisClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	bodyString := string(bodyBytes)

	return &scanResult{
		StatusCode: resp.StatusCode,
		Body:       bodyString,
	}, nil
}

func scan(urlString string, client *http.Client) error {
	// Initialiing http methods
	httpMethods := []string{"ACL", "BASELINE-CONTROL", "BCOPY", "BDELETE", "BMOVE", "BPROPFIND", "BPROPPATCH", "CHECKIN", "CHECKOUT", "CONNECT", "COPY", "DEBUG", "DELETE", "GET", "HEAD", "INDEX", "LABEL", "LOCK", "MERGE", "MKACTIVITY", "MKCOL", "MKWORKSPACE", "MOVE", "NOTIFY", "OPTIONS", "ORDERPATCH", "PATCH", "POLL", "POST", "PROPFIND", "PROPPATCH", "PUT", "REPORT", "RPC_IN_DATA", "RPC_OUT_DATA", "SEARCH", "SUBSCRIBE", "TRACE", "UNCHECKOUT", "UNLOCK", "UNSUBSCRIBE", "UPDATE", "VERSION-CONTROL", "X-MS-ENUMATTS"}
	// UNIX Time is faster and smaller than most timestamps

	for _, method := range httpMethods {

		resp, err := scanSpecific(method, urlString, client)
		if err != nil {
			return err
		}

		switch resp.StatusCode {
		case http.StatusOK:
			log.Info().
				Str("url", urlString).
				Str("method", method).
				Int("status_code:", resp.StatusCode).
				Str("body", resp.Body).
				Msg("200")
		default:
			log.Info().
				Str("url", urlString).
				Str("method", method).
				Int("status_code", resp.StatusCode).
				Msg("non-200")
		}
	}

	return nil
}
