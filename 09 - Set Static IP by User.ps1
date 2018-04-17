param ( [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmIpAddressInput, 
        [Parameter(mandatory=$true)]$vmSubnetMaskInput, 
        [Parameter(mandatory=$true)]$WINSPrimaryIP, 
        [Parameter(mandatory=$true)]$WINSSecondaryIP, 
        [Parameter(mandatory=$true)]$domainFQDN, 
        [Parameter(mandatory=$true)]$vmDefaultGatewayInput, 
        [Parameter(mandatory=$true)]$vmDnsServersInput )
. .\'Result Log.ps1' 
# Step 09 - Set Static IP by User
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