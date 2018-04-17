param ( [Parameter(mandatory=$true)]$ServerInput )
. .\'Result Log.ps1' 
# Step 10 - Disable Windows Firewall.
write_to_log -ServerInput $ServerInput -log_msg "Step 10 - Disable Windows Firewall."
Try {
    Invoke-Command -ComputerName $ServerInput {
        netsh advfirewall set allprofiles state off
    }
}
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}