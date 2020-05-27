# Check Exchange SMTP Logs To Get Unique Sender IP Addresses
 Check Exchange SMTP Logs To Get Unique Sender IP Addresses

.SYNOPSIS
Script is intended to help determine servers that are using an Exchange server to connect and send email.
   
 This is especially pertinent in a decomission scenario, where the logs are to be checked to ensure that all SMTP traffic has been moved to the correct endpoint.
    
 .DESCRIPTION
 Logs on an Exchange 2010 servers are here by default.
 C:\Program Files\Microsoft\Exchange Server\V14\TransportRoles\Logs\ProtocolLog\SmtpReceive
 Note that the script can be easily modified for other versions, or to look at the SMTPSend logs instead. 
 
 An empty array is declared that will be used to hold the data gathered during each iteration.
 This allows for the additional information to be easily added on, and then either echo it to the screen or export to a CSV file
    
 Sample Exchange 2010 SMTP Receive log
 #Software: Microsoft Exchange Server
 #Version: 14.0.0.0
 #Log-type: SMTP Receive Protocol Log
 #Date: 2019-01-25T00:03:58.478Z
 #Fields: date-time,connector-id,session-id,sequence-number,local-endpoint,remote-endpoint,event,data,context
 2019-01-25T00:03:58.478Z,TAIL-EXCH-1\Internet Mail,08D675E58CA1DA38,0,10.0.0.6:25,185.234.217.220:61061,+,,
 2019-01-25T00:03:58.494Z,TAIL-EXCH-1\Internet Mail,08D675E58CA1DA38,1,10.0.0.6:25,185.234.217.220:61061,*,SMTPSubmit SMTPAcceptAnySender SMTPAcceptAuthoritativeDomainSender AcceptRoutingHeaders,Set Session Permissions


.ASSUMPTIONS
    Logging was enabled to generate the required log files.
    Logging was enabled previously, and time was allowed to colled the data in the logs
    Not all activity will be present on a given server.  Will have to check multiple in most deployments.
    Not all activity will be present in the logs.  For example, Exchange maintains 30 days of logs by default.  
    This will not catch connections for processes which send email once a quarter or once a fiscal year.
    Assuption is that something will likely be negatively impacted.  
    Application ownsers should have been told to update their config, so we can say "unlucky" to them...
  
    You can live with the Write-Host cmdlets :)
    You can add your error handling if you need it. 
 
 
.VERSION
 1.0  25-1-2019 -- Initial script released to the scripting gallery
