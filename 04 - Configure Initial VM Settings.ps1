param ( [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmhost, 
        [Parameter(mandatory=$true)]$user,  
        [Parameter(mandatory=$true)][SecureString]$password )
. .\'Result Log.ps1'        
# Step 04 - Configure Initial VM Settings 
write_to_log -ServerInput $ServerInput -log_msg  "Step 04 - Configure Initial VM Settings"
# Set isolation.tools.setinfo.disable equal to false.
write_to_log -ServerInput $ServerInput -log_msg  "    - Set isolation.tools.setinfo.disable equal to false."
Try {
    $SetInfo = Get-VM -Name "$ServerInput" | Get-AdvancedSetting -Name "isolation.tools.setinfo.disable" | Select-Object -ExpandProperty  Value
    if ($SetInfo -eq $true) {
        Get-VM -Name "$ServerInput" | Get-AdvancedSetting -Name 'isolation.tools.setinfo.disable' | Set-AdvancedSetting  -Value 'false' -Confirm:$false
        write_to_log -ServerInput $ServerInput -log_msg  "    Success - Set isolation.tools.setinfo.disable equal to false."
    }
    elseif($SetInfo -eq $null) {
        $vm = Get-VM "$ServerInput"
        New-AdvancedSetting -Entity $vm -Name 'isolation.tools.setinfo.disable' -Value 'false' -Confirm:$false
        write_to_log -ServerInput $ServerInput -log_msg  "    Success - Created isolation.tools.setinfo.disable and set to false."
    }
} catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg  $_.Exception.Message -is_error $true
}
# Set Memory and number of CPU.
write_to_log -ServerInput $ServerInput -log_msg  "    - Set Memory and number of CPU."
Try {
    Set-VM $ServerInput -MemoryGB 8 -numcpu 2 -Confirm:$false
    write_to_log -ServerInput $ServerInput -log_msg  "    Success - Set Memory and number of CPU."
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg  $_.Exception.Message -is_error $true
}
# Floppy drive 1 on the virtual machine (VM) has been removed.
write_to_log -ServerInput $ServerInput -log_msg  "    - Floppy drive 1 on the virtual machine (VM) has been removed."
Try {
    [string]$floppy = Get-FloppyDrive $ServerInput| out-string
    if ($floppy -ne "") {    
        $flopDrive = Get-FloppyDrive -VM $ServerInput
        Remove-FloppyDrive -Floppy $flopDrive -Confirm:$false
        write_to_log -ServerInput $ServerInput -log_msg  "    Success - Floppy drive 1 on the virtual machine (VM) has been removed."
    }
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg  $_.Exception.Message -is_error $true
}
Disconnect-VIServer -Server $Server -confirm:$false