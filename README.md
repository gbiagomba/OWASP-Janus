# OWASP-Janus
This will test various HTTP Request types against a web server. This tool was named after the roman god of choices, cause you know you are testing for HTTP options ☺️.

![alt tag](https://images.squarespace-cdn.com/content/v1/5b0c0ce212b13f38032df407/1546345063175-WFZGSLS422WOYRZB448U/ke17ZwdGBToddI8pDm48kOTw0z0GRa9jLSnKi1NEowhZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpxPd_n6sohiW4hfnzFrq19wzNMyVyLKwqapB1v2VBra5epUCc2oVatrtGzV2lrE7v8/God-Janus-Image-xn903.jpg)

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
janus -u http://www.example.com
janus -iL web_targets.list -o filename.txt
```

*To scan a specific target*
```
janus -u http://www.example.com
```
*To scan multiple targets*
```
janus -iL web_targets.list -o filename.txt
```

## References
1. http://www.cgisecurity.com/whitehat-mirror/WH-WhitePaper_XST_ebook.pdf
2. https://cwe.mitre.org/data/definitions/16.html
3. https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/07-Input_Validation_Testing/03-Testing_for_HTTP_Verb_Tampering
4. https://www.kb.cert.org/vuls/id/867593/
5. https://www.owasp.org/index.php/Testing_for_HTTP_Methods_and_XST_(OWASP-CM-008)
