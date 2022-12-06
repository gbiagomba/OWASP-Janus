# OWASP-Janus
![GitHub](https://img.shields.io/github/license/Achiefs/fim)
[![Tip Me via PayPal](https://img.shields.io/badge/PayPal-tip_me-green?logo=paypal)](paypal.me/gbiagomba)
This will test various HTTP Request types against a web server. This tool was named after the roman god of choices, cause you know you are testing for HTTP options ☺️.

![image](https://live.staticflickr.com/5223/5693358859_6e2e49185d_b.jpg)
<br/>["Janus DDC_4291"](https://www.flickr.com/photos/40936370@N00/5693358859) by [Abode of Chaos](https://www.flickr.com/photos/40936370@N00) is licensed under [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/?ref=ccsearch&atype=rich)

## Install
```
go install github.com/gbiagomba/GoJanus@latest
```

## Usage
```
Usage:
-h, --help               show brief help
-iL, --target-file       specify the target list
-m, --http-method        specify the http request method you want to use (default: 27 methods are checked)
-o, --output             specify the output file (default: stdout)
-t, --threads            specify the number of threads when evoking targetfile (default 10)
-u, --url-target         specify the url (http://www.example.com)

Example:
janus scan -u http://www.example.com
```

*To scan a specific target*
```
janus scan -u http://www.example.com
```
*To scan multiple targets*
```
janus scan -iL web_targets.list -o filename.txt
```

## References
1. http://www.cgisecurity.com/whitehat-mirror/WH-WhitePaper_XST_ebook.pdf
2. https://cwe.mitre.org/data/definitions/16.html
3. https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/07-Input_Validation_Testing/03-Testing_for_HTTP_Verb_Tampering
4. https://www.kb.cert.org/vuls/id/867593/
5. https://www.owasp.org/index.php/Testing_for_HTTP_Methods_and_XST_(OWASP-CM-008)
