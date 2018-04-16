param ( [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmhost, 
        [Parameter(mandatory=$true)]$user,  
        [Parameter(mandatory=$true)][SecureString]$password )
. .\'Result Log.ps1'
$Server = Connect-VIServer -Server $vmhost -User $user -Password $password
# Network interface card (NIC) adapter.
write_to_log -ServerInput $ServerInput "    - Network interface card (NIC) adapter type is VMXNET3."
$oldAdapter = Get-NetworkAdapter -VM $ServerInput
Try {
    Set-NetworkAdapter  -NetworkAdapter $oldAdapter -WakeOnLan:$false -StartConnected:$true -Type 'Vmxnet3' -Connected:$true -RunAsync:$false -Confirm:$false  
    write_to_log -ServerInput $ServerInput "    Success - Network interface card (NIC) adapter set successfully."
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput $_.Exception.Message -is_error $true
}
# Step 06 - Set VM Tools Current
write_to_log -ServerInput $ServerInput "Step 06 - Set VM Tools Current"
Try {
    $ToolsInstalled = (Get-VM -Name "$ServerInput" | Get-View).Guest.ToolsVersionStatus
    if ($ToolsInstalled -ne "guestToolsCurrent") {
        Get-VM $ServerInput | Update-Tools –NoReboot
    }
    if ($ToolsInstalled -eq "guestToolsCurrent") {
        write_to_log -ServerInput $ServerInput "    Success - Step  06 - Set VM Tools Current."
    }
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput $_.Exception.Message -is_error $true
}
Disconnect-VIServer -Server $Server -confirm:$false