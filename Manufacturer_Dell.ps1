##Get BIOS Info
$biosinfo = Get-CimInstance -ClassName Win32_ComputerSystem

#Manufacturer
$manufacturer = $biosinfo.Manufacturer

#Check if it's a Dell
if ($manufacturer -like "*Dell*") {
    $manufacturer = "Dell"
}
else {
    $manufacturer = "Unsupported"
}

$ComplianceOBJ = @{ Manufacturer = $manufacturer}
return $ComplianceOBJ | ConvertTo-Json -Compress