
<# 

.SYNOPSIS
    Script is intended to help determine servers that are using an Exchange server to connect and send email.
    
    This is especially pertinent in a decomission scenario, where the logs are to be checked to ensure that all SMTP traffic has been moved to the correct endpoint.



.DESCRIPTION

    Logs on an Exchange 2010 servers are here by default.
    C:\Program Files\Microsoft\Exchange Server\V14\TransportRoles\Logs\ProtocolLog\SmtpReceive

    Note that the script can be easily modified for other versions, or to look at the SMTPSend logs instead.  

	
    An empty array is declared that will be used to hold the data gathered during each iteration. 
    This allows for the additional information to be easily added on, and then either echo it to the screen or export to a CSV file



	# Sample Exchange 2010 SMTP Receive log

	#	#Software: Microsoft Exchange Server
	#	#Version: 14.0.0.0
	#	#Log-type: SMTP Receive Protocol Log
	#	#Date: 2019-01-25T00:03:58.478Z
	#	#Fields: date-time,connector-id,session-id,sequence-number,local-endpoint,remote-endpoint,event,data,context
	#	2019-01-25T00:03:58.478Z,TAIL-EXCH-1\Internet Mail,08D675E58CA1DA38,0,10.0.0.6:25,185.234.217.220:61061,+,,
	#	2019-01-25T00:03:58.494Z,TAIL-EXCH-1\Internet Mail,08D675E58CA1DA38,1,10.0.0.6:25,185.234.217.220:61061,*,SMTPSubmit SMTPAcceptAnySender SMTPAcceptAuthoritativeDomainSender AcceptRoutingHeaders,Set Session Permissions


.ASSUMPTIONS
    Logging was enabled to generate the required log files.
    Logging was enabled previously, and time was allowed to colled the data in the logs

    Not all activity will be present on a given server.  Will have to check multiple in most deployments.
    Not all activity will be present in the logs.  For example, Exchange maintains 30 days of logs by default.  This will not catch connections for processes whicj
    send email once a quarter or once a fiscal year.

    Assuption is that something will likely be negatively impacted.  Application ownsers should have been told to update their config, so we can say "unlucky" to them...

	You can live with the Write-Host cmdlets :) 

	You can add your error handling if you need it.  

	

.VERSION
  
	1.0  25-1-2019 -- Initial script released to the scripting gallery
    



This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, 
provided that You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
Please note: None of the conditions outlined in the disclaimer above will supercede the terms and conditions contained within the Premier Customer Services Description.
This posting is provided "AS IS" with no warranties, and confers no rights. 

Use of included script samples are subject to the terms specified at http://www.microsoft.com/info/cpyright.htm.

#>


# Tidy up the screen to meet my OCD needs
Clear-Host

# Declare an empty array to hold the output
$Output = @()

$LogFilePath = "C:\Program Files\Microsoft\Exchange Server\V14\TransportRoles\Logs\ProtocolLog\SmtpReceive\*.log"


# Change to suit the particular input location etc.  
$LogFiles = Get-Item  $LogFilePath

# Use an array around the $logFiles to work out the count.  Needed for later to display the progress bar
$Count = @($logfiles).count



ForEach ($Log in $LogFiles)
{
	# Write a handy dandy progress bar to the screen so that we know how far along this is...
	# Increment the counter 
	$Int = $Int + 1
	# Work out the current percentage 
	$Percent = $Int/$Count * 100
	
	# Write the progress bar out with the necessary verbiage....
	Write-Progress -Activity "Collecting Log details" -Status "Processing log File $Int of $Count - $LogFile" -PercentComplete $Percent 

    Write-Host "Processing Log File  $Log" -ForegroundColor Magenta
	Write-Host
	
	# Skip the first 5 lines of the file as they are headers we do not want to review
	$FileContent = Get-Content $Log | Select-Object -Skip 5



	# Retrieve Element Number 5 from the log - this will be the field named "remote-endpoint" 
	# Note that the array is zero based 


	ForEach ($Line IN $FileContent)
	{

		$Socket = $Line  | Foreach {$_.split(",")[5] }

		# This will return data in the form of the socket used - IP and ephemeral TCP port
		# 185.234.217.220:61061
		# Split this so that only the IP is retained, burn the rest!
		$IP = $Socket.Split(":")[0]


		# Append  current results to final output
  		$Output += $IP


	} 

 


} 

	
# Get rid of the duplicates
$Output = $Output | Select-Object -Unique
		
# Now sort it, just because we can...
$Output = $Output | Sort-Object

#Write to the screen.  Disable this is you want...
Write-Host "List of noted remove IPs:" 
$Output
Write-Host 



# The Output.txt file is located in the same folder as the script.  This is the $PWD or Present Working Directory. 
$Output | Out-File $PWD\Output.txt 


