Configuration WebAdministrationDeployment {
 
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -Name Script
 
    Node $AllNodes.NodeName {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $false
            ConfigurationMode = "ApplyOnly"
        }
        Script "WebConfigPropertyCollection1"
        {
            SetScript = {
                $NonNodeRequestVerbsData = @{
                    GET = "True"
                    POST = "True"
                    RPC_IN_DATA = "True"
                    RPC_OUT_DATA = "True"
                    IFQPEE = "False"
                    OPTIONS = "False"
                    TRACE = "False"
                    TRACK = "False"
                    SEARCH = "False"
                    PROPFIND = "False"
                    HEAD = "False"
                    NESSUS = "False"
                    PUT = "False"
                }
 
                $WebsitePath = "MACHINE/WEBROOT/APPHOST"
                $Filter = "system.webServer/security/requestFiltering"
                $Verbs = Get-WebConfigurationProperty -PSPath $WebsitePath -Filter $Filter -Name "Verbs" -Recurse
                foreach ($VerbsData in $NonNodeRequestVerbsData.GetEnumerator())
                {
                    if (! (($Verbs | Where-Object { $_.Collection -ne $null }).Collection | Where-Object { $_.verb -eq "$($VerbsData.Name)" }) )
                    {
                        Add-WebConfigurationProperty -PSPath $WebsitePath -Filter $Filter -Value @{verb="$($VerbsData.Name)";allowed="$($VerbsData.Value)"} -Name "Verbs" -AtIndex 0
                    }
                }
            }
 
            GetScript = {
                $Result = @{ Result = [string[]] }
                Return $Result
            }
 
            TestScript = {
                #$Verbs = Get-CimInstance -Namespace "root\WebAdministration" -ClassName RequestFilteringSection -Property Verbs | Select-Object -ExpandProperty Verbs
                Return $false
            }
        }
    }
} 
 
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        },
        @{
            NodeName = "localhost"
            Role = 'IIS'
        }
    );
    NonNodeData = @{
            Trace = $false
            Options = $false
    }
}
 
New-Item -Path "C:\Temp\WebAdministration" -Type directory -ErrorAction SilentlyContinue
$mof = WebAdministrationDeployment -OutputPath "C:\Temp\WebAdministration" -ConfigurationData $ConfigData
Set-DscLocalConfigurationManager -Verbose -Path "C:\Temp\WebAdministration"
Start-DscConfiguration -Path "C:\Temp\WebAdministration" -Wait -Force -Verbose