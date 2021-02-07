# This program performs basic artifact collection for Incident Response
# Written by Katie Zurowski, 2019
# Published Jan 2021 to GitHub

#This is the destination drive where your output files will be created
$destinationDrive = Read-Host("Enter the destination Drive")

#Case information
$investigator= Read-Host("Enter Investigator Name")
Write-Output "Collection Script Output Files" | Out-File $destinationDrive\caseInfo.txt 
Write-Output "Collection Start Time:" | Out-File $destinationDrive\caseInfo.txt -append -nonewline
Get-Date | Out-File $destinationDrive\caseInfo.txt -append
Write-Output "Investigator:" $investigator | Out-File $destinationDrive\caseInfo.txt -append
Write-Output "This collection program was created by Katie Zurowski for coursework at George Mason University"

#OS data
Get-WmiObject win32_operatingsystem | Out-File $destinationDrive\osInfo.txt

#Network Data
Get-NetNeighbor | Out-File $destinationDrive\arpcache.csv
Get-NetTCPConnection | Out-File $destinationDrive\ports.txt
Get-DnsClientCache | Out-File $destinationDrive\DNSCache.txt
Get-NetRoute | Out-File $destinationDrive\IPRouteTable.txt
Get-NetAdapter | ConvertTo-html| Out-File $destinationDrive\MACInfo.html
Get-NetIPAddress | Out-File $destinationDrive\IPInterface.txt

#Services and Processes
Get-Service | ConvertTo-html | Out-File $destinationDrive\services.html
Get-Process | ConvertTo-Html | Out-File $destinationDrive\processes.html

#Event log data
Get-EventLog -logname System | ConvertTo-html | Out-File $destinationDrive\sysEvents.html
Get-EventLog -logname Security | ConvertTo-html | Out-File $destinationDrive\secEvents.html
Get-EventLog -logname Application | ConvertTo-html | Out-File $destinationDrive\appEvents.html

#File information, includes outputs for entire file system, and specifically prefetch to ease of use
Get-ChildItem -Path C:\ -Recurse | Select-Object -Property fullname, creationtime, lastaccesstime, lastwrittentime, length |ConvertTo-html | Out-File $destinationDrive\directoryinfo.html
Get-ChildItem -path C:\Windows\Prefetch | select-object -Property name, lastwritetime | convertTo-html |out-file $destinationDrive\prefetch.html

#Retreives any hotfixes and patches that are on the device
Get-HotFix | Out-File $destinationDrive\hotfixes.csv

#Finishing info: end times and file hashes of generated files
Write-Output "Collection End Time:" | Out-File $destinationDrive\caseInfo.txt -append -nonewline
Get-Date | Out-File $destinationDrive\caseInfo.txt -append

$path = Get-ChildItem $destinationDrive
ForEach ($i in $path){
    Get-FileHash $i.FullName -Algorithm MD5 | Format-List | out-file $destinationDrive\hashes.txt -Append
}


Write-Host "Script complete."