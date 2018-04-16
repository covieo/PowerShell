param ( [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmhost, 
        [Parameter(mandatory=$true)]$user,  
        [Parameter(mandatory=$true)][SecureString]$password )
. .\'Result Log.ps1'
$Server = Connect-VIServer -Server $vmhost -User $user -Password $password
# Step 05 - Power On VM
write_to_log -ServerInput $ServerInput -log_msg "Step 05 - Power On VM"
Try {
    Start-VM -VM $ServerInput -Confirm:$false
    write_to_log -ServerInput $ServerInput -log_msg "    Success - Step 05 - Power On VM."
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}
Disconnect-VIServer -Server $Server -confirm:$false