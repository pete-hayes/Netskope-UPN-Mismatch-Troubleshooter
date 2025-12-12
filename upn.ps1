[CmdletBinding()]
param (
    # Netskope tenant domain, e.g., example.goskope.com
    [Parameter(Mandatory)]
    [string]$TenantDomain,

    # SCIM API bearer token
    [Parameter(Mandatory)]
    [string]$ApiKey,

    # Optional username or UPN override
    # If not provided, whoami /upn is used
    [string]$Username
)

$ErrorActionPreference = 'Stop'

# Netskope Base SCIM Users endpoint
$BaseUrl = "https://$TenantDomain/api/v2/scim/Users"

# Request headers
$Headers = @{
    accept        = 'application/scim+json;charset=utf-8'
    Authorization = "Bearer $ApiKey"
}

# Determine lookup value
# User provided value or UPN of logged-on user
$lookup = if ($Username) { $Username.Trim() } else { (whoami /upn).Trim() }
Write-Host "Lookup value: $lookup"

# Run SCIM API Users query against the username provided
function Query-Scim($field) {
    # Build and encode SCIM filter
    $filter = [uri]::EscapeDataString("$field eq `"$lookup`"")

    Invoke-RestMethod `
        -Method Get `
        -Uri "${BaseUrl}?filter=$filter" `
        -Headers $Headers
}

# First check: userName match
# This represents the correct identity mapping!
Write-Host "Searching by userName"
$resp = Query-Scim 'userName'

if ($resp.totalResults -gt 0) {
    Write-Host "MATCH FOUND (userName)"
    Write-Host "userName: $lookup"
    exit 0
}

# Second check: email match
# Indicates user exists but UPN does not match provisioned userName
Write-Host "Searching by emails"
$resp = Query-Scim 'emails'

if ($resp.totalResults -gt 0) {
    $provisioned = $resp.Resources[0].userName

    Write-Host "USER FOUND BY EMAIL"
    Write-Host "UPN MISMATCH"
    Write-Host "Lookup UPN      : $lookup"
    Write-Host "Provisioned UPN : $provisioned"

    exit 2
}

# No matches found
Write-Host "NO MATCH FOUND. User does not exist."
exit 1
