$ServiceName = "SCardSvr"

#get service info
$ServiceStatus = Get-Service | Where-Object {$_.Name -eq $ServiceName} | select name, status

#createobject
$ComplianceOBJ = "" | Select ServiceName,ServiceStatus
$ComplianceOBJ.ServiceName = $ServiceStatus.Name
$ComplianceOBJ.ServiceStatus = $ServiceStatus.Status.ToString()

#convert into json
#$ComplianceOBJ | convertto-json -Compress
$ComplianceOBJ | Select ServiceName,ServiceStatus | ConvertTo-Json -Compress