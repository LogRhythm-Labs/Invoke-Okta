
    Invoke-Okta
    LogRhythm Security Operations
    greg . foss @ logrhythm . com
    v1.0  --  May, 2018

Copyright 2018 LogRhythm Inc.   
Licensed under the MIT License. See LICENSE file in the project root for full license information.


## [About]
    
Collection of useful commands for easy interaction with Okta, focused on SIEM Automation for the LogRhythm platform.

This script is also integrated directly into the LogRhythm SIEM as a [SmartResponse](https://logrhythm.com/solutions/security/security-automation-and-orchestration/).

Blog Post => TBD


## [PowerShell Installation and Usage]

#### Import The Module
	
	PS C:\> Import-Module .\Invoke-Okta.ps1

#### Run the following command for a list of options associated with this script:

    PS C:\> Invoke-okta -help

#### Command details:

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
        PS C:\> Invoke-Okta -userName <username>  -clearSessions

        Suspend Okta User Account
        PS C:\> Invoke-Okta -userName <username>  -suspend

        Un-Suspend Okta User Account
        PS C:\> Invoke-Okta -userName <username>  -unSuspend

        Reset Okta User Password
        PS C:\> Invoke-Okta -userName <username> -resetPassword

        Unlock Okta User's Account
        PS C:\> Invoke-Okta -userName <username> -unlock

    ************************************************************

    All arguments require an administrative Okta API key and the corporate domain-name (normally company.okta.com)
        -key <api key> -domain <corporate domain>


## [LogRhythm Integration]

Import the LogRhythm Dashboard to track Okta user activity across all of your connected apps

Import Alarms to trigger on events of interest


## [License]

Copyright 2018 LogRhythm Inc.   
Licensed under the MIT License. See LICENSE file in the project root for full license information.
