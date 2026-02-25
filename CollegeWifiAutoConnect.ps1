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
    username = "2023b1531145"
    password = "Far86320"
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
