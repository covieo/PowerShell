param ( $ServerInput, $vmIpAddressInput, $vmSubnetMaskInput, $WINSPrimaryIP, $WINSSecondaryIP, $domainFQDN, $vmDefaultGatewayInput, $vmDnsServersInput )
. .\'Result Log.ps1' 
# Step 08 - Set Static IP by User
write_to_log -ServerInput $ServerInput -log_msg "Step 08 - Set Static IP by User."
Try {
    Set-ExecutionPolicy RemoteSigned
    $wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
    $wmi.EnableStatic("$vmIpAddressInput", "$vmSubnetMaskInput")

    $wmi.SetWINSServer("$WINSPrimaryIP","$WINSSecondaryIP")
    $wmi.SetDNSDomain("$domainFQDN")
    $wmi.SetTcpipNetbios("EnableNetbios")

    $wmi.SetGateways("$vmDefaultGatewayInput", 1)
    $wmi.SetDNSServerSearchOrder("$vmDnsServersInput")
}
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}