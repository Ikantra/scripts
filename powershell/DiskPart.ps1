#------------------------------------------------------------------------------  
#  
# Copyright © 2014 Microsoft Corporation.  All rights reserved.  
#  
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT  
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT  
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS  
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR   
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.  
#  
#------------------------------------------------------------------------------  
#  
# PowerShell Source Code  
#  
# NAME:  
#    DiskPart.ps1  
#  
# VERSION:  
#    1.1 
#  
#------------------------------------------------------------------------------ 

$dpscript = @"
list volume
list disk
list vdisk
"@

[array]$Temp = $dpscript | diskpart

ForEach ($Line in $Temp)
{
	If ($Line.StartsWith("  Volume"))
	{
		[array]$Vols += $Line
	}
	ElseIf ($Line.StartsWith("  Disk"))
	{
		[array]$Disks += $Line
	}
	ElseIf ($Line.StartsWith("  VDisk"))
	{
		[array]$VDisks += $Line
	}
}

$VolCount = $Vols.Count
$DiskCount = $Disks.Count
$VDiskCount = $VDisks.Count

For ($i=1;$i -le ($Vols.count-1);$i++)
{
	$currLine = $Vols[$i]
	$currLine -Match "  Volume (?<volnum>...) +(?<drltr>...) +(?<lbl>...........) +(?<fs>.....) +(?<typ>..........) +(?<sz>.......) +(?<sts>.........) +(?<nfo>........)" | Out-Null
	$VolObj =  New-Object PSObject
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "VolumeNumber" -Value $Matches['volnum'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Letter" -Value $Matches['drltr'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Label" -Value $Matches['lbl'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "FileSystem" -Value $Matches['fs'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Type" -Value $Matches['typ'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Size" -Value $Matches['sz'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Status" -Value $Matches['sts'].Trim()
	Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Info" -Value $Matches['nfo'].Trim()
	$dpscript = @"
select volume $($VolObj.VolumeNumber)
detail volume
"@
	[array]$Temp = $dpscript | diskpart
	
	ForEach ($Line in $Temp)
	{
		If ($Line.StartsWith("Read-only") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "ReadOnly" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Hidden") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Hidden" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("No Default Drive Letter") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "NoDefaultDriveLetter" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Shadow Copy") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "ShadowCopy" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Offline") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Offline" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("BitLocker Encrypted") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "BitLockerEncrypted" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Installable") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "Installable" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Volume Capacity") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "VolumeCapacity" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Volume Free Space") -and $Line -match ":")
		{
			Add-Member -InputObject $VolObj -MemberType NoteProperty -Name "VolumeFreeSpace" -Value $Line.Split(":")[1].Trim()
		}
	}
	
	[array]$VolResults += $VolObj
}

For ($i=1;$i -le ($Disks.count-1);$i++)
{
	$currLine = $Disks[$i]
	$currLine -Match "  Disk (?<disknum>...) +(?<sts>.............) +(?<sz>.......) +(?<fr>.......) +(?<dyn>...) +(?<gpt>...)" | Out-Null
	$DiskObj =  New-Object PSObject
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DiskNumber" -Value $Matches['disknum'].Trim()
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Status" -Value $Matches['sts'].Trim()
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Size" -Value $Matches['sz'].Trim()
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Free" -Value $Matches['fr'].Trim()
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Dyn" -Value $Matches['dyn'].Trim()
	Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Gpt" -Value $Matches['gpt'].Trim()
	$dpscript = @"
select disk $($DiskObj.DiskNumber)
detail disk
"@
	[array]$Temp = $dpscript | diskpart
	
	ForEach ($Line in $Temp)
	{
		If ($Line -cmatch "Disk ID" -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DiskID" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Type") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DetailType" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Status") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DetailStatus" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Path") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Path" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Target") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Target" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("LUN ID") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "LUNID" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Location Path") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "LocationPath" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Current Read-only State") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "CurrentReadOnlyState" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Read-only") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "ReadOnly" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Boot Disk") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "BootDisk" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Pagefile Disk") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "PagefileDisk" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Hibernation File Disk") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "HibernationFileDisk" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Crashdump Disk") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "CrashdumpDisk" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Clustered Disk") -and $Line -match ":")
		{
			Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "ClusteredDisk" -Value $Line.Split(":")[1].Trim()
		}
	}
	
	[array]$DiskResults += $DiskObj
}

For ($i=1;$i -le ($VDisks.count-1);$i++)
{
	$currLine = $VDisks[$i]
	$currLine -Match "  VDisk (?<vdisknum>...) +(?<phydisknum>........) +(?<state>....................) +(?<type>.........) +(?<file>.+)" | Out-Null
	$VDiskObj =  New-Object PSObject
	Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "VDiskNumber" -Value $Matches['vdisknum'].Trim()
	Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "PhysicalDiskNumber" -Value $Matches['phydisknum'].Trim()
	Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "State" -Value $Matches['state'].Trim()
	Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "Type" -Value $Matches['type'].Trim()
	Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "File" -Value $Matches['file'].Trim()
	$dpscript = @"
select vdisk file=$($VDiskObj.File)
detail vdisk
"@
	[array]$Temp = $dpscript | diskpart
	
	ForEach ($Line in $Temp)
	{
		If ($Line -cmatch "Device type ID" -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "DeviceTypeId" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Vendor ID") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "VendorId" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("State") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "DetailState" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Virtual size") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "VirtualSize" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Physical size") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "PhysicalSize" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Is Child") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "IsChild" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Parent Filename") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "ParentFileName" -Value $Line.Split(":")[1].Trim()
		}
		ElseIf ($Line.StartsWith("Associated disk#") -and $Line -match ":")
		{
			Add-Member -InputObject $VDiskObj -MemberType NoteProperty -Name "AssociatedDiskNum" -Value $Line.Split(":")[1].Trim()
		}
	}
	
	[array]$VDiskResults += $VDiskObj
}

$VolResults
$DiskResults
$VDiskResults