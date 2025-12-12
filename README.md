# Netskope UPN Mismatch Troubleshooter
The Netskope Client automatic enrollment mode with Windows requires the username of the logged in user to match the value provisioned to Netskope from the directory source, such as Entra ID or Active Directory.

In some environments, a mismatch can occur where the Windows logon username does not align with the value provisioned to Netskope. For example, a user may log in with an ID like `emp0123457`, while Netskope is provisioned with their email address. This tool detects this condition, commonly referred to as a UPN mismatch, and helps confirm when the Netskope userName attribute should be mapped to a different directory attribute.

## Features
- Automatically validates the logged in user’s User Principal Name (UPN) against the `userName` attribute provisioned in Netskope
- Detects and reports when a user is found via email but does not match the provisioned `userName` value, indicating a UPN mismatch
- Reports when a user cannot be found in Netskope using either the `userName` or `emails` attributes

## Requirements
- PowerShell 5.1 or newer
- Access to the Netskope SCIM API
- A Netskope SCIM API token with permission to read Users & Groups.

## Usage

### Automatically Validate Logged-In User
1. Clone or download this repository, e.g., 
    - `Invoke-WebRequest -Uri https://raw.githubusercontent.com/pete-hayes/Netskope-UPN-Mismatch-Troubleshooter/main/upn.ps1 -OutFile upn.ps1`
2. `.\upn.ps1 -TenantDomain example.goskope.com -ApiKey <API_TOKEN>`

### Manual Validation
1. Clone or download this repository, e.g., 
    - `Invoke-WebRequest -Uri https://raw.githubusercontent.com/pete-hayes/Netskope-UPN-Mismatch-Troubleshooter/main/upn.ps1 -OutFile upn.ps1`
2. `.\upn.ps1 -TenantDomain example.goskope.com -ApiKey <API_TOKEN> -Username example@example.com`

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
UPN MISMATCH DETECTED
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
