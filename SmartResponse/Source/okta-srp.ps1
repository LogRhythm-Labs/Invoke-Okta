
#================================#
#       Okta SmartResponse       #
# LogRhythm Security Operations  #
# greg . foss @ logrhythm . com  #
# v1.0  --  May, 2018            #
#================================#

# Copyright 2018 LogRhythm Inc.   
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

<#

.Synopsis
Interact with the Okta API quickly and easily

.Usage
Install the module:
    PS C:\> Import the module into the SIEM and configure as a SmartResponse
#>

[CmdLetBinding()]
param( 
    [string]$key,
    [string]$domain,
    [string]$userName,
    [string]$setPassword,
    [switch]$help,
    [switch]$appLinks,
    [switch]$clearSessions,
    [switch]$suspend,
    [switch]$unSuspend,
    [switch]$unlock,
    [switch]$resetPassword
)

# Core Parameters
$url = "https://$domain.okta.com"
$token = "SSWS $key"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-type", "application/json")
$headers.Add("Authorization", $token)
$userAgent = "Invoke-Okta 1.0 - LogRhythm Security Operations"

# User Searches and Actions
if ( $userName ) {

    # Find User
    $oktaUrl = "$url/api/v1/users?q=$userName"
    $output = Invoke-RestMethod -uri $oktaUrl -headers $headers -Method GET -UserAgent $userAgent
    $userId = $output.id

    if ( $clearSessions ) {

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
        
        # Unlock Okta Account
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