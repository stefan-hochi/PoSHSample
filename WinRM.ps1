#region
#Enables WinRM and Config Firewall Rules
Enable-PSRemoting
#endregion

#region
#Mixed Domain require to allow from differnt Domain
New-Itemproperty -name LocalAccountTokenFilterPolicy -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -propertyType DWord -value 1
Get-ItemProperty -Name LocalAccountTokenFilterPolicy -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
#endregion

#region
#Trusted Hosts
Get-Item wsman:localhost\client\trustedhosts
Set-Item wsman:localhost\client\trustedhosts -value RM-Client1,RM-Client2
#endregion