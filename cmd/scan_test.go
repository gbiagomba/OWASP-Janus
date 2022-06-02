/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"fmt"
	"io"
	"net/http"
	"reflect"
	"strings"
	"testing"
)

type fakeTransport struct {
	http.RoundTripper
}

func (f *fakeTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	switch r.Method {
	// GET's 200
	case http.MethodGet:
		return &http.Response{
			StatusCode: 200,
			Body:       io.NopCloser(strings.NewReader("Hello")),
		}, nil
		// OPTIONS calls throw errors
	case http.MethodOptions:
		return nil, fmt.Errorf("I've fallen and I can't get up.")
	default:
		// Everything else 404s
		return &http.Response{
			StatusCode: 404,
			Body:       io.NopCloser(strings.NewReader("Not Here")),
		}, nil
	}
}

func Test_scanSpecific(t *testing.T) {
	testClient := &http.Client{
		Transport: &fakeTransport{},
	}

	type args struct {
		method string
		url    string
		client *http.Client
	}
	tests := []struct {
		name    string
		args    args
		want    *scanResult
		wantErr bool
	}{
		{
			name: "I got a 200",
			args: args{
				method: "GET",
				url:    "http://example.com",
				client: testClient,
			},
			want: &scanResult{
				StatusCode: 200,
				Body:       "Hello",
			},
			wantErr: false,
		},
		{
			name: "I got a non-200",
			args: args{
				method: "POST",
				url:    "http://example.com",
				client: testClient,
			},
			want: &scanResult{
				StatusCode: 404,
				Body:       "Not Here",
			},
			wantErr: false,
		},
		{
			name: "I got an http error",
			args: args{
				method: "OPTIONS",
				url:    "http://example.com",
				client: testClient,
			},
			want:    nil,
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := scanSpecific(tt.args.method, tt.args.url, tt.args.client)
			if (err != nil) != tt.wantErr {
				t.Errorf("scanSpecific() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("scanSpecific() = %v, want %v", got, tt.want)
			}
		})
	}
}
