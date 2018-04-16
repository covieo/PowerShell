param ( [Parameter(mandatory=$true)]$CustomizationTemplateNameInput, 
        [Parameter(mandatory=$true)]$vmDnsServersInput, 
        [Parameter(mandatory=$true)]$ServerInput, 
        [Parameter(mandatory=$true)]$vmhost, 
        [Parameter(mandatory=$true)]$user, 
        [Parameter(mandatory=$true)][SecureString] $password, 
        [Parameter(mandatory=$true)]$ipAddress, 
        [Parameter(mandatory=$true)]$subnetMask, 
        [Parameter(mandatory=$true)]$defaultGateway, 
        [Parameter(mandatory=$true)]$templateName, 
        [Parameter(mandatory=$true)]$newvmLocation, 
        [Parameter(mandatory=$true)]$newvmVMHost, 
        [Parameter(mandatory=$true)]$newvmDatastore )
. .\'Result Log.ps1'        
# Step 03 - Deploy VM From Template
write_to_log -ServerInput $ServerInput -log_msg "Step 03 - Deploy VM From Template"
$Server = Connect-VIServer -Server $vmhost -User $user -Password $password
Try {
    Get-OSCustomizationNicMapping -spec $CustomizationTemplateNameInput | ? { $_.Position -eq '1' } | Set-OSCustomizationNicMapping -IpMode:UseStaticIP -IpAddress $ipAddress -SubnetMask $subnetMask -Dns $vmDnsServersInput -DefaultGateway $defaultGateway
    $template = Get-Template  -Name $templateName
    New-vm -Name $ServerInput -Location $newvmLocation -VMHost $newvmVMHost -Template $template -Datastore $newvmDatastore -OSCustomizationspec $CustomizationTemplateNameInput
    write_to_log -ServerInput $ServerInput -log_msg "Success - Step 03 - Deploy VM From Template"    
} 
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
} 
Disconnect-VIServer -Server $Server -confirm:$false