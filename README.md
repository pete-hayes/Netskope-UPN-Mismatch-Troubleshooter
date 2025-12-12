# Netskope UPN Mismatch Troubleshooter

## Requirements
- PowerShell 5.1 or newer
- Access to the Netskope SCIM API
- A Netskope SCIM API token with permission to read Users & Groups.

## Usage

### Validate Logged-In User
1. Clone or download this repository.
2. `.\upn.ps1 -TenantDomain example.goskope.com -ApiKey <SCIM_API_KEY>`

### Validate User-Provided Username
1. Clone or download this repository.
2. `.\upn.ps1 -TenantDomain example.goskope.com -ApiKey <SCIM_API_KEY> -Username example@example.com`

## Example Outputs

### UPN Match (Success)
```
Lookup value: example@example.com
Searching by userName
MATCH FOUND (userName)
userName: example@example.com
```

### UPN Mismatch (Fail)
```
Lookup value: example@example.com
Searching by userName
Searching by emails
USER FOUND BY EMAIL
UPN MISMATCH
Lookup UPN      : example@example.com
Provisioned UPN : example@example.net
```

### User Not Found (Fail)
```
Lookup value: example@example.com
Searching by userName
Searching by emails
NO MATCH FOUND. User does not exist.
```


## License
Licensed under MIT — free to use, modify, and share, with no warranty.

## Disclaimer
This project is **not affiliated with or supported by Netskope**. It may be incomplete, outdated, or inaccurate. Use at your own risk.
