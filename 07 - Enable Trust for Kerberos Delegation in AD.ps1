param ( [Parameter(mandatory=$true)]$ServerInput, [Parameter(mandatory=$true)]$ADComputerPath )
. .\'Result Log.ps1'
# Step 07 - Enable Trust for Kerberos Delegation in AD. 
write_to_log -ServerInput $ServerInput -log_msg "Step 07 - Enable Trust for Kerberos Delegation in AD"
Try {
    $ldap = Get-ADComputer $ServerInput |  Select-Object -ExpandPropert DistinguishedName
}
catch [System.Exception] {
    New-ADComputer -Name $ServerInput -Path $ADComputerPath
}
Try {	
    $TRUSTED_FOR_DELEGATION = 524288;	
    $dn      = "LDAP://"+ $ldap
    $account = New-Object System.DirectoryServices.DirectoryEntry($dn)
    $uac     = $account.userAccountControl[0] -bor $TRUSTED_FOR_DELEGATION
    $account.userAccountControl[0]=$uac	
    $account.CommitChanges()
    write_to_log -ServerInput $ServerInput -log_msg "    Success - Step 07 - Enable Trust for Kerberos Delegation in AD."
}
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}