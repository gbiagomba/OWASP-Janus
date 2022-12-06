<!-- AUTO-GENERATED, DO NOT EDIT! -->
<!-- Please edit the original at https://github.com/ory/meta/blob/master/templates/repository/common/SECURITY.md -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Security Policy](#security-policy)
  - [Supported Versions](#supported-versions)
  - [Reporting a Vulnerability](#reporting-a-vulnerability)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Security Policy

  * [Reporting a Vulnerability](#reporting-a-vulnerability)
  * [Disclosure Policy](#disclosure-policy)

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for
receiving such patches depends on the CVSS v3.0 Rating:

| CVSS v3.0 | Supported Versions                        |
| --------- | ----------------------------------------- |
| 9.0-10.0  | Releases within the previous three months |
| 4.0-8.9   | Most recent release                       |

## Reporting a Vulnerability

Please report (suspected) security vulnerabilities to
**[gilles.infosec@gmail.com](mailto:gilles.infosec@gmail.com)**.
You will receive a response from us within 48 hours. If the issue is confirmed,
we will release a patch as soon as possible depending on complexity
but historically within a few days.

## Disclosure Policy

When the security team receives a security bug report, they will assign it
to a primary handler. This person will coordinate the fix and release
process, involving the following steps:

  * Confirm the problem and determine the affected versions.
  * Audit code to find any potential similar problems.
  * Prepare fixes for all releases still under maintenance. These fixes
    will be released as fast as possible to NPM.
