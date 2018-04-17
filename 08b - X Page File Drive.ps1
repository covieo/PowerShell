param ( [Parameter(mandatory=$true)]$ServerInput )
. .\'Result Log.ps1' 
# Step 08b - X Page File Drive
write_to_log -ServerInput $ServerInput -log_msg "Step 08b - X Page File Drive."
Try {
#first we find and initialize physical disks with no partitions 
$drives = gwmi Win32_diskdrive 
$scriptdisk = $Null
$script = $Null
foreach ($disk in $drives){
    if ($disk.Partitions -eq "0"){
        $drivenumber = $disk.DeviceID -replace '[\\\\\.\\physicaldrive]',''        
$script = @"
select disk $drivenumber
online disk noerr
attributes disk clear readonly noerr
create partition primary noerr
format quick
"@
}
$drivenumber = $Null
$scriptdisk += $script + "`n"
}
$scriptdisk | diskpart
$volumes = gwmi Win32_volume  | where {$_.BootVolume -ne $True -and $_.SystemVolume -ne $True -and $_.DriveType -eq "3"} | SELECT DeviceID
foreach ($volume in $volumes)
{
    if ($volume.DriveLetter -eq $Null)
    {
        mountvol "X:" $volume.DeviceID
    }
}
$sh=New-Object -com Shell.Application
$sh.NameSpace('X:').Self.Name = 'Page File'

$computer = Get-WmiObject Win32_computersystem -EnableAllPrivileges
$computer.AutomaticManagedPagefile = $false
$computer.Put()
$CurrentPageFile = Get-WmiObject -Query "select * from Win32_PageFileSetting where name='c:\\pagefile.sys'"
$CurrentPageFile.delete()
Set-WMIInstance -Class Win32_PageFileSetting -Arguments @{name="x:\pagefile.sys";InitialSize = 0; MaximumSize = 0}
    write_to_log -ServerInput $ServerInput -log_msg "    Success - Step 08b - X Page File Drive."
}
catch [System.Exception] {
    write_to_log -ServerInput $ServerInput -log_msg $_.Exception.Message -is_error $true
}
