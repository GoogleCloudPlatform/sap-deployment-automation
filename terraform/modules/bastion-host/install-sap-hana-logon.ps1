###################     Logs files    ###################
if (!(Test-PATH 'C:\Logs\SAPGUI_errors.txt')) { 
	New-Item -Path 'C:\Logs\SAPGUI_errors.txt' -ItemType File -Force
}
if (!(Test-PATH 'C:\Logs\HanaStudio_errors.txt')) {
	New-Item -Path 'C:\Logs\HanaStudio_errors.txt' -ItemType File -Force	
}
if (!(Test-PATH 'C:\Logs\OpenJDK_errors.txt')) { 
	New-Item -Path 'C:\Logs\OpenJDK_errors.txt' -ItemType File -Force
}
if (!(Test-PATH 'C:\Logs\OpenJDK8U-jre_x64_install_log.log')) { 
	New-Item -Path 'C:\Logs\OpenJDK8U-jre_x64_install_log.log' -ItemType File -Force
}
if (!(Test-PATH 'C:\Logs\OpenJDK8U-jre_x32_install_log.log')) { 
	New-Item -Path 'C:\Logs\OpenJDK8U-jre_x32_install_log.log' -ItemType File -Force
}
if (!(Test-PATH 'C:\Logs\Chrome_errors.txt')) { 
	New-Item -Path 'C:\Logs\Chrome_errors.txt' -ItemType File -Force
}

###################     Common Variable     ###################

$GSBucket = "gs://" + "${BucketFolder}"

###################     Check if OpenJDK8U-jre is installed    ###################
try {
	if (Test-Path 'HKLM:\SOFTWARE\AdoptOpenJDK\JRE\') {
		$out = &"java.exe" -version 2>&1 
		for($i = 0; $i -lt $out.length; $i++){ $out[$i].tostring() }  ### Print the Java version
	}
	else {
		"Java is not installed. Installing OpenJDK8U-jre ..."
		$Path = "C:\Program Files"
		$Installer32 = "OpenJDK8U-jre_x86-32_windows_hotspot_8u275b01.msi"
		$Installer64 = "OpenJDK8U-jre_x64_windows_hotspot_8u275b01.msi"
		gsutil cp  $GSBucket/$Installer32 $Path\$Installer32 ### Copy OpenJDK msi 32
		gsutil cp  $GSBucket/$Installer64 $Path\$Installer64 ### Copy OpenJDK msi 64
        ### Install OpenJDK MSI in silent mode
		$MSIInstallArguments32 = @(
			"/i"
			'"C:\Program Files\OpenJDK8U-jre_x86-32_windows_hotspot_8u275b01.msi"'
			"/quiet"
			"/norestart"
			"/l*v"
			'"C:\Logs\OpenJDK8U-jre_x32_install_log.log"'
		)
		Start-Process "msiexec.exe" -ArgumentList $MSIInstallArguments32 -Wait -Verb RunAs        ### Install OpenJDK MSI 32 in silent mode
		$MSIInstallArguments64 = @(
			"/i"
			'"C:\Program Files\OpenJDK8U-jre_x64_windows_hotspot_8u275b01.msi"'
			"/quiet"
			"/norestart"
			"/l*v"
			'"C:\Logs\OpenJDK8U-jre_x64_install_log.log"'
		)
		Start-Process "msiexec.exe" -ArgumentList $MSIInstallArguments64 -Wait -Verb RunAs        ### Install OpenJDK MSI 64 in silent mode
		Write-Host "OpenJDK8U-jre installation done."
		Remove-Item -Path $Path\$Installer32 -Force
		Remove-Item -Path $Path\$Installer64 -Force
	}
}
catch {
	Write-Host "Error installing OpenJDK. Check the error logs C:\Logs."
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\OpenJDK_errors.txt -Append
	$_ | Out-File C:\Logs\OpenJDK_errors.txt -Append
}

###################     Check if Chrome is installed    ###################
try {
	if (!(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe')) {
		Write-Host "Chrome is not installed. Installing Chrome ..."
		#$Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer;
		$Path = "C:\Program Files"; $Installer = "ChromeSetup.exe"
		gsutil cp  $GSBucket/$Installer $Path\$Installer                               		            ### Copy ChromeSetup.exe
		Start-Process -FilePath $Path\$Installer -ArgumentList "/silent /install" -Verb RunAs -Wait     ### Install Chrome
		Write-Host "Chrome installation done."
		Remove-Item -Path $Path\$Installer -Force
	}
	else {
		Write-Host "Chrome is already installed."
	}
}
catch {
	Write-Host "Error installing Chrome. Check the error logs C:\Logs."
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\Chrome_errors.txt -Append
	$_ | Out-File C:\Logs\Chrome_errors.txt -Append
}

################### Check if SAP GUI Logon is installed ###################
try {
	if (Test-Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SAPGUI') {
		$SAPGUI = (gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SAPGUI).displayname 
		Write-Host $SAPGUI
	}
	else {
		Write-Host "SAP GUI Logon is not installed. Installing SAP Logon ..."
		$Path = "C:\Program Files"
		$InstallerSAPGUI = "SAPGUIWin.exe"
		gsutil cp  $GSBucket/$InstallerSAPGUI $Path\$InstallerSAPGUI                        ### Copy SAP GUI Win package for SAP Logon
		Start-Process -FilePath $Path\$InstallerSAPGUI -ArgumentList '/silent'              ### Install SAP GUI Logon
	}
}
catch {
	Write-Host "Error installing SAP GUI Logon. Check the error logs C:\Logs."
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\SAPGUI_errors.txt -Append
	$_ | Out-File C:\Logs\SAPGUI_errors.txt -Append
}

###################          Check if SAP HANA STUDIO is Installed           ###################
try {
	if (!((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).displayname -contains "SAP HANA Studio 64bit")) {
		
		Write-Host "SAP Hana Studio is not installed. Installing SAP Hana Studio ..."
		$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")          ### update the env path variable
		$Path = "C:\Program Files"
		$InstallerHanaZip = "SAP_HANA_STUDIO.zip"
		gsutil cp  $GSBucket/$InstallerHanaZip $Path\$InstallerHanaZip    					### Copy SAP Hana Studio.zip
	    
		# Unzip the SAP_HANA_STUDIO.zip file
		$zipfile = $Path + "\" + $InstallerHanaZip
		$destinationpath = "C:\Program Files\"
		Expand-Archive -Path $zipfile -DestinationPath $destinationpath -Force
	  
		$config_file="C:\Program Files\SAP_HANA_STUDIO\config_file"
		$hanapathsetup="C:\Program Files\SAP_HANA_STUDIO\hdbinst.exe"	
		######## Check if the Hana Studio Config File Exist #############
		if (!([System.IO.File]::Exists($config_file))) {
			Start-Process -FilePath $hanapathsetup -ArgumentList ('-b','--dump_configfile_template="C:\Program Files\SAP_HANA_STUDIO\config_file"') -Wait  ### Create Config File
		}
		Start-Process -FilePath $hanapathsetup -ArgumentList ('-b','--configfile="C:\Program Files\SAP_HANA_STUDIO\config_file"') -Verb RunAs -Wait  ### Install SAP Hana Studio
	  
		######## Create Hana Studio Shortcut ###########
		$SourceFileLocation = "C:\Program Files\sap\hdbstudio\hdbstudio.exe"
		$ShortcutLocation = "C:\Users\Public\Desktop\hdbstudio.lnk"   
		if (!([System.IO.File]::Exists($ShortcutLocation))) {
			$WScriptShell = New-Object -ComObject WScript.Shell
			$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
			$Shortcut.TargetPath = $SourceFileLocation
			$Shortcut.Save()                                                                 ### Create SAP Hana Studio Shortcut
		}
		Write-Host "SAP Hana Studio installation done."
		Remove-Item -Path $Path\$InstallerHanaZip -Force
	}
	else {
		Write-Host "SAP Hana Studio already installed."
	}
}
catch {
	Write-Host "Error installing SAP Hana Studio. Check the error logs C:\Logs."
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\HanaStudio_errors.txt -Append
	$_ | Out-File C:\Logs\HanaStudio_errors.txt -Append
}


######################         Delete setup files            #######################

if (Test-PATH 'C:\Program Files\SAPGUIWin.exe') { 
	Remove-Item -Path 'C:\Program Files\SAPGUIWin.exe' -Force
}

######################