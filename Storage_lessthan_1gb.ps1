$freeStorage = [math]::Round((Get-PSDrive -Name C).Free / 1024 / 1024 / 1024)

$ComplianceOBJ = @{ FreeStorage = $freeStorage}

return $ComplianceOBJ | ConvertTo-Json -Compress