param ([Parameter(mandatory=$true)]$domainFQDN, [Parameter(mandatory=$true)]$vmDnsServersInput, [Parameter(mandatory=$true)]$ServerInput)
. .\'Result Log.ps1'
write_to_log -ServerInput $ServerInput -log_msg "PS Server Build W2K8"
write_to_log -ServerInput $ServerInput -log_msg "Virtual Only - VMware Build"
# Step 01 - Delete DNS Record(s) 
write_to_log -ServerInput $ServerInput -log_msg "Step 01 - Delete DNS Record(s)"
Try {
    foreach ($DnsServer in $vmDnsServersInput) {
        #dnscmd.exe $DnsServer /RecordDelete $domainFQDN $ServerInput A /f
    }
    write_to_log -ServerInput $ServerInput -log_msg "Success - Step 01 - Delete DNS Record(s)"
} catch [System.Exception]
{
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}