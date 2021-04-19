#convert user mailbox to a shared mailbox

#connect to exchange online
try
{
    get-mailbox -ErrorAction Stop > $null
}
catch 
{
Connect-exchangeonline
}

#get username
$currentuser = read-host "Enter the username of the account to convert: "

#convert to shared
set-mailbox $currentuser -type shared

#add other user to shared mailbox
$setnewpermissions = Read-Host "Do you want to add a user to the new share? (yes/no): "

#decision tree to add a new user
switch ( $setnewpermissions )
{
    "yes" { $newmailboxpermissions = Read-host "Enter the username for the shared mailbox user: " }
    "no" { Write-host "Finished" }
}

#add the user
Add-MailboxPermission -Identity $currentuser -AccessRights FullAccess -InheritanceType All -AutoMapping:$true -User $newmailboxpermissions


#test if converted
get-mailbox -Identity $currentuser | Format-List Recipienttypedetails

