<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '720,300'
$Form.text                       = "PAW BAR Tool"
$Form.BackColor                  = "#ffffff"
$Form.TopMost                    = $false

$ComboBox1                       = New-Object system.Windows.Forms.ComboBox
$ComboBox1.text                  = "Actions"
$ComboBox1.width                 = 152
$ComboBox1.height                = 20
@('Backup to USB','Backup to Network','Restore from USB','Restore from Network','Delete old profiles') | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
$ComboBox1.location              = New-Object System.Drawing.Point(35,80)
$ComboBox1.Font                  = 'Microsoft Sans Serif,10'

$ComboBox2                       = New-Object system.Windows.Forms.ComboBox
$ComboBox2.text                  = "Select Profile"
Get-ChildItem -Path $PSScriptRoot\res\profiles | ForEach-Object {$combobox2.Items.Add($_)}
$ComboBox2.width                 = 152
$ComboBox2.height                = 20
$ComboBox2.location              = New-Object System.Drawing.Point(35,160)
$ComboBox2.Font                  = 'Microsoft Sans Serif,10'
$ComboBox2.Enabled               = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Select the action"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(35,50)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 460
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(235,80)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'
$TextBox1.Enabled                = $false
$TextBox1.Text                   = $null

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Type the Network location"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(235,50)
$Label2.Font                     = 'Microsoft Sans Serif,10'

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Start"
$Button1.width                   = 100
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(595,157)
$Button1.Font                    = 'Microsoft Sans Serif,10'
$Button1.BackColor               = "green"

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Delete"
$Button2.width                   = 100
$Button2.height                  = 30
$Button2.location                = New-Object System.Drawing.Point(235,157)
$Button2.Font                    = 'Microsoft Sans Serif,10'
$Button2.Enabled                 = $false

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "Delete"
$Button3.width                   = 100
$Button3.height                  = 30
$Button3.location                = New-Object System.Drawing.Point(500,160)
$Button3.Font                    = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($ComboBox1,$ComboBox2,$Label1,$TextBox1,$Label2,$Button1,$Button2))

$basepath = $PSScriptRoot

$ComboBox1.Add_SelectedIndexChanged({ 
    switch ($ComboBox1.SelectedIndex){
        0 {
            
            Write-Host $ComboBox1.SelectedItem
            $TextBox1.Enabled = $false
            $ComboBox2.Enabled = $false
            $Button2.Enabled = $false
            $button1.Enabled = $true
            $button2.BackColor = "white"
            $button1.BackColor = "green"
            }
        1 {
            Write-Host $ComboBox1.SelectedItem
            $TextBox1.Enabled = $true
            $ComboBox2.Enabled = $False
            $Button2.Enabled = $false
            $button1.Enabled = $true
            $button2.BackColor = "white"
            $button1.BackColor = "green"
            }
        2 {
            Write-Host $ComboBox1.SelectedItem
            $TextBox1.Enabled = $false
            $ComboBox2.Enabled = $true
            $Button2.Enabled = $false
            $button1.Enabled = $true
            $button2.BackColor = "white"
            $button1.BackColor = "green"
            
            
            }
        3 {
            Write-Host $ComboBox1.SelectedItem
            $TextBox1.Enabled = $true
            $Button2.Enabled = $false
            $ComboBox2.Enabled = $true
            $button1.Enabled = $true
            $button2.BackColor = "white"
            $button1.BackColor = "green"
            
            }
        4 {
            $Button2.Enabled = $true
            $button2.BackColor = "red"
            $ComboBox2.Enabled = $true
            $TextBox1.Enabled = $false
            $button1.Enabled = $false
            $button1.BackColor = "white"
            }
        }
 })

 $Button1.add_click({
    if ($TextBox1.Enabled -eq $true){
        write-host "the box is enabled"
        if ($TextBox1.TextLength -ne "0"){
        $testp = test-path -Path $textbox1.Text
            if ($testp -eq $true){
                write-host "path $testp exists"
            }
    }
    else {
        write-host "box is empty"
        }
    }
    

    write-host "button clicked"

    switch ($ComboBox1.SelectedIndex){
        0 {
            
            start $basepath\res\usb.bat -Wait -Verb runas
            
            }
        1 {
            $networkpath = $TextBox1.Text
            $networktext = $PSScriptRoot + "\res\amd64\scanstate " + $networkpath + $env:COMPUTERNAME + " /i:" + $PSScriptRoot + "\res\amd64\miguser.xml i:/" + $PSScriptRoot + "\res\amd64\migapp.xml /c /o /r:1 /w:5 /uel:30"
            New-Item -path $basepath\res\network.bat -ItemType File -Value $networktext -force
            start $basepath\res\network.bat -Wait -Verb runas
            write-host "Copy is done"
            }
        2 {
            Write-Host $ComboBox1.SelectedItem
            $loadpc = $ComboBox2.SelectedItem
            $TextBox1.Enabled = $false
            $restoretext = $PSScriptRoot + "\res\amd64\loadstate " + $PSScriptRoot + " \res\profiles\" + $loadpc + " /i:" + $PSScriptRoot + "\res\amd64\miguser.xml i:/" + $PSScriptRoot + "\res\amd64\migapp.xml /all"
            New-Item -path $basepath\res\restore.bat -ItemType File -Value $restoretext -force
            start $basepath\res\restore.bat -Wait -Verb runas
            }
        3 {
            $networkpath = $TextBox1.Text
            $ComboBox2.Items.Clear()
            Get-ChildItem -path $networkpath | foreach { $combobox2.Items.Add($_) }
            $loadpc = $ComboBox2.SelectedItem
            Write-Host $ComboBox1.SelectedItem
            $TextBox1.Enabled = $true
            $restoretext = $PSScriptRoot + "\res\amd64\loadstate " + $networkpath + $loadpc + $ComboBox2.SelectedItem + " \res\profiles\" + $loadpc + " /i:" + $PSScriptRoot + "\res\amd64\miguser.xml i:/" + $PSScriptRoot + "\res\amd64\migapp.xml /all"
            New-Item -path $basepath\res\networkrestore.bat -ItemType File -Value $restoretext -force
            start $basepath\res\networkrestore.bat -Wait -Verb runas
            
            }
        }


    
     })

$ComboBox2.add_click({
$ComboBox2.Items.Clear()
if ($ComboBox1.SelectedIndex -eq "3"){
    $ComboBox2.Items.Clear()
            Get-ChildItem -path $networkpath | foreach { $combobox2.Items.Add($_) }
            }
            else {
            Get-ChildItem -Path $PSScriptRoot\res\profiles | ForEach-Object {$combobox2.Items.Add($_)}
            }


})


$Button2.add_click({
$delpath = "$PSScriptRoot\res\profiles\" + $combobox2.SelectedItem
Remove-Item -Path $delpath -recurse -Force
$Form.ShowDialog()
})

#Write your logic code here

[void]$Form.ShowDialog()