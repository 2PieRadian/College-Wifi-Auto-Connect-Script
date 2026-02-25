# WiFi Captive Portal Automation --- Beginner to Advanced Documentation

## Introduction

This document explains, in complete technical detail, how the provided
PowerShell script works.\
It is written for absolute beginners --- even those who have never coded
before.

The script automates logging into a WiFi captive portal (such as a
college WiFi login page).

---

# Table of Contents

1. What is PowerShell?
2. What is a Captive Portal?
3. What is HTTP?
4. What is a Web Session?
5. Full Script
6. Line‑by‑Line Explanation
7. Core Technical Concepts Explained
8. Security Implications
9. Summary

---

# 1. What is PowerShell?

PowerShell is a scripting language and command-line shell developed by
Microsoft.

It allows users to: - Control the operating system - Run system
commands - Automate repetitive tasks - Interact with networks - Make web
requests

PowerShell is built on top of the .NET Framework, meaning it can use
powerful system libraries.

---

# 2. What is a Captive Portal?

A captive portal is a network authentication system.

When you connect to certain WiFi networks: - You connect to the router -
But you cannot access the internet yet - You must log in through a web
page first

This login page is called a captive portal.

Technically: - The router intercepts all outgoing web requests -
Redirects them to a login server - After authentication, it allows
traffic through the firewall

---

# 3. What is HTTP?

HTTP (HyperText Transfer Protocol) is the communication protocol used by
web browsers.

Two important request types:

GET\
Used to request data.

POST\
Used to send data to a server.

This script uses both.

---

# 4. What is a Web Session?

When you log into a website, it remembers you.

This is done using: - Cookies - Session IDs

A session maintains identity between multiple requests.

Without session handling: - Login requests may fail - Server may not
recognize your identity

---

# 5. Full Script

```powershell
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$wifiName = "ABESEC"

netsh wlan connect name="$wifiName"

do {
    Start-Sleep -Seconds 1
    $status = netsh wlan show interfaces
} until ($status -match "State\s+:\s+connected")

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

$timestamp = [int64]((Get-Date).ToUniversalTime() - [datetime]'1970-01-01').TotalMilliseconds

$loginUrl = "https://192.168.1.254:8090/login.xml"

$body = @{
    mode = "191"
    username = "YOUR_USERNAME"
    password = "YOUR_PASSWORD"
    a = "$timestamp"
    producttype = "0"
}

Invoke-WebRequest -Uri "http://www.google.com" `
    -WebSession $session `
    -UseBasicParsing `
    -ErrorAction SilentlyContinue | Out-Null

Invoke-WebRequest `
    -Uri $loginUrl `
    -Method POST `
    -Body $body `
    -WebSession $session `
    -UseBasicParsing | Out-Null
```

---

# 6. Line‑by‑Line Explanation

## Disable Certificate Validation

This line forces PowerShell to trust HTTPS certificates even if invalid.

Normally: - HTTPS certificates are verified - Self-signed certificates
fail verification

This bypasses that check.

Security Risk: This disables protection against man-in-the-middle
attacks.

---

## Store WiFi Name

Stores the WiFi network name in a variable.

Variables store data for later use.

---

## Connect to WiFi

Uses Windows networking command (netsh) to connect to WiFi.

Equivalent to clicking the WiFi manually.

---

## Wait Until Connected

A loop repeatedly checks connection status every second.

The loop stops only when it detects: State : connected

Uses pattern matching (regular expressions).

---

## Create Web Session

Creates a session object that stores cookies and authentication data.

This simulates a browser session.

---

## Generate Unix Timestamp

Generates the number of milliseconds since January 1, 1970 (UTC).

This is called Unix Epoch Time.

Used to: - Prevent replay attacks - Ensure request freshness

---

## Define Login URL

Points to the captive portal's login endpoint.

192.168.x.x addresses are private network addresses.

---

## Create POST Body

Creates a dictionary of login parameters.

These values simulate form data sent from a browser.

---

## Trigger Captive Portal

Sends an HTTP request to Google.

Why?

Captive portals intercept HTTP traffic and redirect to login page. This
initializes session cookies.

HTTP is used instead of HTTPS because encrypted traffic cannot be
intercepted easily.

---

## Send Login Request

Sends credentials via POST request.

Parameters: - URI: where to send data - Method: POST - Body: form data -
WebSession: maintain cookies

If correct: Router updates firewall rules Internet access is granted

---

# 7. Core Technical Concepts Explained

## Variables

Containers that store data.

## Loops

Repeat execution until condition is met.

## Regular Expressions

Pattern matching used to search text.

## HTTP Requests

Communication between client and server.

## Sessions & Cookies

Maintain identity across multiple requests.

## SSL Certificates

Verify secure identity of servers.

## Unix Epoch Time

Standardized time measurement used in computing.

---

# 8. Security Implications

Important risks:

- Password stored in plain text
- SSL verification disabled
- Vulnerable to network interception
- Script should never be publicly shared with credentials

Safer alternatives: - Use encrypted credential storage - Use Windows
Credential Manager - Avoid disabling certificate validation if possible

---

# 9. Summary

This script automates:

1. Connecting to WiFi
2. Waiting for network readiness
3. Triggering captive portal
4. Submitting login form
5. Establishing authenticated session

It combines knowledge of:

- Operating Systems
- Networking
- Security
- HTTP Protocol
- Time Standards
- Automation Scripting

Despite being short, it demonstrates deep system interaction concepts.
