/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"crypto/tls"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "janus",
	Short: "A brief description of your application",
	Long: `A longer description that spans multiple lines and likely contains
examples and usage of using your application. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) { },

}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

const (
	headerTimeout = 3 * time.Second
	dialTimeout   = 1 * time.Second
)

var (
	httpClient                *http.Client
	consoleLogger, jsonLogger zerolog.Logger
)

func init() {
	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.

	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.GoJanus.yaml)")

	// Setup our HTTP Client
	dialer := &net.Dialer{
		Timeout: dialTimeout,
	}

	tr := &http.Transport{
		ResponseHeaderTimeout: headerTimeout,
		TLSClientConfig:       &tls.Config{InsecureSkipVerify: true},
		DialContext:           dialer.DialContext,
	}
	httpClient = &http.Client{Transport: tr}

	// Setup Our Logger
	level := zerolog.DebugLevel

	consoleOutput := zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: zerolog.TimeFormatUnix,
	}
	consoleLogger = zerolog.New(consoleOutput).With().Logger().Level(level)

	jsonLogger = zerolog.New(os.Stdout).With().Logger().Level(level)

	log.Logger = consoleLogger

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")

}
