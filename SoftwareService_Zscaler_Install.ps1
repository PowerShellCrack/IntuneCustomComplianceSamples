$AppName = "Zscaler"
$ServiceName = "ZSAService"

function Get-InstalledSoftware {
    <#
    .SYNOPSIS
        Retrieves a list of all software installed

    .PARAMETER Name
        The software title you'd like to limit the query to.

    .PARAMETER IncludeExeTypes
        Inlcudes non MSI instaled apps

    .EXAMPLE
        Get-InstalledSoftware
        This example retrieves all software installed on the local computer

    .EXAMPLE
        Get-InstalledSoftware -IncludeExeTypes
        This example retrieves all software installed on the local computer
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [switch]$IncludeExeTypes
    )

    $UninstallKeys = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall","HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root Registry::HKEY_USERS -ErrorAction SilentlyContinue
    $UninstallKeys += Get-ChildItem HKU: -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' } | ForEach-Object { "HKU:\$($_.PSChildName)\Software\Microsoft\Windows\CurrentVersion\Uninstall" }
    
	if (-not $UninstallKeys) {
        Write-Verbose 'No software registry keys found'
    } else {
        foreach ($UninstallKey in $UninstallKeys) {

            If($PSBoundParameters.ContainsKey('Name')){
                $NameFilter = "$Name*"
            }Else{
                $NameFilter = "*"
            }

            if ($PSBoundParameters.ContainsKey('IncludeExeTypes')) {
                $WhereBlock = { ($_.PSChildName -like '*') -and ($_.GetValue('DisplayName') -like $NameFilter) -and (-Not[string]::IsNullOrEmpty($_.GetValue('DisplayName'))) }
            } else {
                $WhereBlock = { ($_.PSChildName -match '^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$') -and ($_.GetValue('DisplayName') -like $NameFilter) -and (-Not[string]::IsNullOrEmpty($_.GetValue('DisplayName'))) }
            }

            $gciParams = @{
                Path        = $UninstallKey
                ErrorAction = 'SilentlyContinue'
            }
            $selectProperties = @(
                @{n='Name'; e={$_.GetValue('DisplayName')}},
                @{n='GUID'; e={$_.PSChildName}},
                @{n='Version'; e={$_.GetValue('DisplayVersion')}},
                @{n='Uninstall'; e={$_.GetValue('UninstallString')}}
            )
            Get-ChildItem @gciParams | Where-Object $WhereBlock | Select-Object -Property $selectProperties
        }
    }
}

#get software info
$SoftwareVersion = Get-InstalledSoftware -IncludeExeTypes -Name $AppName | select name, version
$ServiceStatus = Get-Service | Where-Object {$_.Name -like $ServiceName} | select name, status

#createobject
$ComplianceOBJ = "" | Select AppName,AppVersion,ServiceName,ServiceStatus
$ComplianceOBJ.AppName = $SoftwareVersion.Name
$ComplianceOBJ.AppVersion = $SoftwareVersion.Version
$ComplianceOBJ.ServiceName = $ServiceStatus.Name
$ComplianceOBJ.ServiceStatus = $ServiceStatus.Status.ToString()

#convert into json
#$ComplianceOBJ | convertto-json -Compress
$ComplianceOBJ | Select AppName,AppVersion,ServiceName,ServiceStatus | ConvertTo-Json -Compress