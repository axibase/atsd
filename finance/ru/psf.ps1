param([string]$path)

$Headers = @{Authorization = "Bearer <API_TOKEN>"}
# https://atsd_hostname:8443/api/v1/trades/upload
$Uri = 'http://atsd_hostname:8088/api/v1/trades/upload'

$Form = @{
    insert = "true"
    debug = "true"
    file = Get-Item -Path $path
}

Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Post -Form $Form