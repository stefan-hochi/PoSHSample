$FormatEnumerationLimit=-1
Get-Process -Name svchost | ForEach-Object -Process { 
Get-WmiObject Win32_Service -Filter "ProcessId=$($_.Id)" } | Group-Object ProcessId |
Select-Object @{n="ProcessId";e={$_.Name}},
@{n='User';e={(Get-WmiObject Win32_Process -Filter "ProcessID=$($_.Name)").GetOwner() | Select-Object -ExpandProperty User}},
@{n="ServiceName";e={((Get-Service ($_.Group | 
Select-Object -ExpandProperty Name)).DisplayName) -join [System.Environment]::NewLine}} |
Format-List ProcessId,User,ServiceName