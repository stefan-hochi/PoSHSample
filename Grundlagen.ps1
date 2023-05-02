#region
<# Grundlagen
Objektorientiert auf .NET
Beispiel Get-Help: Get ist gleich Verb, Help ist gleich Nomen
#>
Get-Help
Get-Command
Get-Member
 
Get-Help Get-Content-ShowWindow # Option ShowWindow ab PowerShell 3.0
#endregion

#region
<# Formatierung
#>
Format-Table -Property Name,@{n="VM";e={$_.VM/1MB}; formatstring='N2'; align='left'}
Format-Table -Property Name,@{n="VM";e={"{0:N2}" -f ($_.VM/1MB)}}
#endregion

#region
<# Sonstiges
#>
# aktuelle Pipline-Objecte in Scriptblock
$_
$PSItem # ab PowerShell 3.0
 
# Script Blocks
{}
 
# Hash Tables / Dictionary
@{}
 
# Array / Listen
@()
 
# Direktvariable / Subexpression
$()
 
#endregion

#region
<# Alias
#>
% # ForEach-Object
? # Where-Object
sls # Select-String Alias ab PowerShell 3.0
#endregion