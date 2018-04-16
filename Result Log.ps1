# write_to_log - F U N C T I O N  T O  W R I T E  T E S T  O U T P U T  T O  F I L E
Function write_to_log ( [Parameter(mandatory=$true)]$ServerInput, 
                        [Parameter(mandatory=$true)]$log_msg, 
                        [Parameter(mandatory=$false)]$is_error ) 
{
    # The output file containg test results (output from this script)
    [string]$myResultsFile	= "C:\Temp\" + $ServerInput + "_Creation_Results.txt"	
    if(!(Test-Path $myResultsFile))
    {
        # I N I T I A L I Z E  L O G  F I L E
        $today = Get-Date
        "POST $ServerInput SERVER Creation on $today" | Out-File $myResultsFile 
    }
	if ($is_error -eq $true) {
    	# to log file    	
    	"ERROR  ->    $log_msg " | Out-File $myResultsFile -Append 
    	" " | Out-File $myResultsFile -Append
	}
	else {
		# to log file
        $log_msg | Out-File $myResultsFile -Append
    }    
	return " "
}