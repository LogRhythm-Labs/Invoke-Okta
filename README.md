
    Invoke-Okta
    LogRhythm Security Operations
    greg . foss @ logrhythm . com
    v1.0  --  May, 2018

Copyright 2018 LogRhythm Inc.   
Licensed under the MIT License. See LICENSE file in the project root for full license information.


## [About]
    
Collection of useful commands for easy interaction with Okta, focused on SIEM Automation for the LogRhythm platform.

This script is also integrated directly into the LogRhythm SIEM as a [SmartResponse](https://logrhythm.com/solutions/security/security-automation-and-orchestration/).

Blog Post => [https://logrhythm.com/blog/take-the-first-steps-towards-a-zero-trust-model-with-okta-automation/](https://logrhythm.com/blog/take-the-first-steps-towards-a-zero-trust-model-with-okta-automation/)


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

#### Import the LogRhythm Dashboard to track Okta user activity across all of your connected apps

Configure Okta to forward logs to LogRhythm using the API integration: [Exporting Okta Log Data](https://support.okta.com/help/Documentation/Knowledge_Article/Exporting-Okta-Log-Data)

![LogRhythm Dashboard](https://user-images.githubusercontent.com/727732/40144233-266dc638-591b-11e8-9e3a-f84495727604.png)

#### Import Alarms to trigger on events of interest

Brute Force Detection:
![Brute Force AIE Rule](https://user-images.githubusercontent.com/727732/40144280-53a46be8-591b-11e8-9b39-1c521bfae713.png)

API Token Creation:
![API Token Creation](https://user-images.githubusercontent.com/727732/40144322-7015fbde-591b-11e8-92bf-bf6392d615a9.png)

Failed Multifactor Authentication:
![Failed MFA](https://user-images.githubusercontent.com/727732/40144364-8c8c570e-591b-11e8-80f7-177d9ec4be4b.png)

User Locked Out:
![User Locked Out](https://user-images.githubusercontent.com/727732/40144375-9a914fb2-591b-11e8-86f6-cee2415ec72a.png)

#### Take this a step further with SmartResponse Automation

![SmartResponse Automation](https://user-images.githubusercontent.com/727732/40144407-bef7c76e-591b-11e8-8267-e0a873729088.png)

## [License]

Copyright 2018 LogRhythm Inc.   
Licensed under the MIT License. See LICENSE file in the project root for full license information.
