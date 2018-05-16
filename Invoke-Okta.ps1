
  #================================#
  #          Invoke-Okta           #
  # LogRhythm Security Operations  #
  # greg . foss @ logrhythm . com  #
  # v1.0  --  May, 2018            #
  #================================#

# Copyright 2018 LogRhythm Inc.   
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

function Invoke-Okta {

<#

.Synopsis
    Interact with the Okta API quickly and easily

.Usage
    Install the module:
        PS C:\> Import-Module Invoke-Okta.ps1

    View the help menu for usage information:
        PS C:\> Invoke-Okta -help
#>

    [CmdLetBinding()]
    param( 
        [string]$key,
        [string]$domain,
        [string]$userName,
        [string]$setPassword,
        [switch]$help,
        [switch]$listUsers,
        [switch]$deprovisionedUsers,
        [switch]$lockedUsers,
        [switch]$appLinks,
        [switch]$clearSessions,
        [switch]$suspend,
        [switch]$unSuspend,
        [switch]$unlock,
        [switch]$resetPassword
    )


    $banner = @"
   ____              __           ____  __   __      
  /  _/__ _  _____  / /_____ ____/ __ \/ /__/ /____ _
 _/ // _ \ |/ / _ \/  '_/ -_)___/ /_/ /  '_/ __/ _ `/
/___/_//_/___/\___/_/\_\\__/    \____/_/\_\\__/\_,_/ 
                                                     
"@

    $usage = @"
    
    General Information Gathering:
        
        List information about an Okta user
        PS C:\> Invoke-Okta -userName <username> 

        List all application links for a specific Okta user
        PS C:\> Invoke-Okta -userName <username>  -appLinks
            
        List all Okta users
        PS C:\> Invoke-Okta -listUsers 

        List all locked Okta users
        PS C:\> Invoke-Okta -lockedUsers 
        
        List all deprovisioned Okta users
        PS C:\> Invoke-Okta -deprovisioned 

    End-user actions:

        Clear user's sessions across all Okta-integrated applications
        PS C:\> Invoke-Okta -userName <username> -clearSessions

        Suspend Okta User Account
        PS C:\> Invoke-Okta -userName <username> -suspend

        Un-Suspend Okta User Account
        PS C:\> Invoke-Okta -userName <username> -unSuspend

        Reset Okta User Password
        PS C:\> Invoke-Okta -userName <username> -resetPassword

        Unlock Okta User's Account
        PS C:\> Invoke-Okta -userName <username> -unlock

    ************************************************************

    All arguments require an administrative Okta API key and the corporate domain-name (normally company.okta.com)
        -key <api key> -domain <corporate domain>
"@

if ( $help ) {

    Write-Host $banner -ForegroundColor Green
    Write-Host $usage
    Write-Host ""
    break;
    
}
    
    # Core Parameters
    $url = "https://$domain.okta.com"
    $token = "SSWS $key"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-type", "application/json")
    $headers.Add("Authorization", $token)
    $userAgent = "Invoke-Okta 1.0 - LogRhythm Security Operations"

    # List All Users
    if ( $listUsers ) {

        $oktaUrl = "$url/api/v1/users"
        $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
        $output.profile | Out-GridView
    }

    # List Deprovisioned Users
    if ( $deprovisionedUsers ) {

        $oktaUrl = "$url/api/v1/users?filter=status%20eq%20%22DEPROVISIONED%22"
        $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
        $output.profile | Out-GridView
    }

    # List Locked Out Users
    if ( $lockedUsers ) {

        $oktaUrl = "$url/api/v1/users?filter=status%20eq%20%22LOCKED_OUT%22"
        $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
        $output.profile | Out-GridView
    }

    # User Searches and Actions
    if ( $userName ) {
    
        # Find User
        $oktaUrl = "$url/api/v1/users?q=$userName"
        $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
        $userId = $output.id

        if ( $appLinks ) {

            # Get Application Links
            $oktaUrl = "$url/api/v1/users/$userId/appLinks"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
            $output | Out-GridView

        } elseif ( $clearSessions ) {

            # Clear User Sessions
            $oktaUrl ="$url/api/v1/users/$userId/sessions"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method DELETE -UserAgent $userAgent
            Write-Host ""
            Write-Host " [ + ] All active sessions terminated for " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName" 
            Write-Host ""

        } elseif ( $suspend ) {

            # Suspend User Account
            $oktaUrl = "$url/api/v1/users/$userId/lifecycle/suspend"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method POST -UserAgent $userAgent
            Write-Host ""
            Write-Host " [ + ] User account " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName " -NoNewline
            Write-Host "has been suspended successfully" -ForegroundColor Cyan
            Write-Host ""

        } elseif ( $unSuspend ) {
            
            # Remove User Account Suspension
            $oktaUrl = "$url/api/v1/users/$userId/lifecycle/unsuspend"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method POST -UserAgent $userAgent
            Write-Host ""
            Write-Host " [ + ] User account " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName " -NoNewline
            Write-Host "suspension has been removed" -ForegroundColor Cyan
            Write-Host ""

        } elseif ( $resetPassword ) {
            
            # Reset User Account Password
            $oktaUrl = "$url/api/v1/users/$userId/lifecycle/reset_password?sendEmail=false"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method POST -UserAgent $userAgent
            $resetUrl = $output.resetPasswordUrl
            Write-Host ""
            Write-Host " [ + ] Password has been reset for user account " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName"
            Write-Host " [ + ] Send the following link to the affected user:" -ForegroundColor Cyan
            Write-Host " [ + ]     " -NoNewline -ForegroundColor Cyan
            Write-Host "$resetUrl" -ForegroundColor Yellow
            Write-Host ""
        
        } elseif ( $setPassword ) {

            # Set Password
            $oktaUrl = "$url/api/v1/users/$userId"
            $body = @{
                credentials = @{
                    password = @{ value = "$setPassword" };
                    };
                };
            $payload = $body | ConvertTo-Json
            $output = Invoke-RestMethod -Uri $oktaUrl -Headers $headers -Body $payload -Method Put -UserAgent $userAgent
            Write-Host ""
            Write-Host " [ + ] Password has been set to " -NoNewline -ForegroundColor Cyan
            Write-Host "($setPassword)"
            Write-Host " for user account " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName"
            Write-Host ""

        } elseif ( $unlock ) {
        
            # Unlock User Account
            $oktaUrl = "$url/api/v1/users/$userId/lifecycle/unlock"
            $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method POST -UserAgent $userAgent
            Write-Host ""
            Write-Host " [ + ] User account " -NoNewline -ForegroundColor Cyan
            Write-Host "$userName " -NoNewline
            Write-Host "has been unlocked" -ForegroundColor Cyan
            Write-Host ""
        
        } else {
            
            # Display User Information
            $output.profile
            $output.Credentials.recovery_question
            $output.Credentials.provider
            $output | findstr -i "id status created lastLogin" | findstr -v "credentials"
        }
    }
}
