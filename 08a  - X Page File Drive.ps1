param ( [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmhost, 
        [Parameter(mandatory=$true)]$user,  
        [Parameter(mandatory=$true)][SecureString]$password,
        [Parameter(mandatory=$true)]$vmMemorySizeInput )
. .\'Result Log.ps1'         
# Step 08a - X Page File Drive
write_to_log -ServerInput $ServerInput -log_msg "Step 08a - X Page File Drive."
Try
{
    $mbConversion = $vmMemorySizeInput * 1000
    $capacity     = $mbConversion * 1.5   
    $Server       = Connect-VIServer -Server $vmhost -User $user -Password $password
    Get-VM -Name "$ServerInput" | New-HardDisk -CapacityKB $capacity -Persistence persistent  
    Disconnect-VIServer -Server $Server -confirm:$false
    write_to_log -ServerInput $ServerInput -log_msg "    Success - Step 08a - X Page File Drive."
}
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}