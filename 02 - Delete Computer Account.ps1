param ( [Parameter(mandatory=$true)]$ServerInput )
. .\'Result Log.ps1'
# Step 02 - Delete Computer Account
write_to_log -ServerInput $ServerInput -log_msg "02 - Delete Computer Account"
Try {
    $ComputerToDelete = Get-ADComputer -Identity $ServerInput
    Remove-ADObject -Identity $ComputerToDelete -Recursive -Confirm:$false
    write_to_log -ServerInput $ServerInput -log_msg "Success - Step 02 - Delete Computer Account"
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}