###################     Logs files    ###################
	if (!(Test-PATH 'C:\Logs\SAPGUI_errors.txt')) { 
		New-Item -Path 'C:\Logs\SAPGUI_errors.txt' -ItemType File -Force
	}
	if (!(Test-PATH 'C:\Logs\JavaChrome_errors.txt')) { 
		New-Item -Path 'C:\Logs\JavaChrome_errors.txt' -ItemType File -Force
	}
	if (!(Test-PATH 'C:\Logs\HanaStudio_errors.txt')) {
		New-Item -Path 'C:\Logs\HanaStudio_errors.txt' -ItemType File -Force	
	}

###################     Variables     ###################
$GSBucket = "gs://win-scripts-test"
$Path = "C:\Program Files"

################### Check if JavaChrome.exe is installed ###################
try {
	if (Test-Path 'HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment') {
		$out = &"java.exe" -version 2>&1 
		for($i = 0; $i -lt $out.length; $i++){ $out[$i].tostring() }                ### Print the Java version
	}
	else {
		Write-Host "Java is not installed. Installing OpenJDK JRE ..."
		$InstallerJavaChrome = "JavaChrome.exe"
		gsutil cp  $GSBucket/$InstallerJavaChrome $Path\$InstallerJavaChrome 		### Copy JavaChrome
		Start-Process -FilePath $Path\$InstallerJavaChrome -Wait                    ### Install SAP GUI Logon
		Write-Host "JavaChrome.exe installation done."
	}
}
catch {
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\JavaChrome_errors.txt -Append
	$_ | Out-File C:\Logs\JavaChrome_errors.txt -Append
}

################### Check if SAP GUI Logon is installed ###################
try {
	if (Test-Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SAPGUI') {
		$SAPGUI = (gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\SAPGUI).displayname 
		Write-Host $SAPGUI
	}
	else {
		Write-Host "SAP GUI Logon is not installed. Installing SAP Logon ..."
		$InstallerSAPGUI = "SAPGUIWin.exe"
		gsutil cp  $GSBucket/$InstallerSAPGUI $Path\$InstallerSAPGUI                        ### Copy SAP GUI Win package for SAP Logon
		Start-Process -FilePath $Path\$InstallerSAPGUI -ArgumentList '/silent'              ### Install SAP GUI Logon
	}
}
catch {
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\SAPGUI_errors.txt -Append
	$_ | Out-File C:\Logs\SAPGUI_errors.txt -Append
}

###################  Check if SAP HANA STUDIO is Installed  ###################
try {
	if (!((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).displayname -contains "SAP HANA Studio 64bit")) {
		
		Write-Host "SAP Hana Studio is not installed. Installing SAP Hana Studio ..."
		$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")          ### update the env path variable
		$InstallerHanaZip = "SAP_HANA_STUDIO.zip"
		gsutil cp  $GSBucket/$InstallerHanaZip $Path\$InstallerHanaZip                      ### Copy SAP Hana Studio.zip
	    
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
	}
	else {
		Write-Host "SAP Hana Studio already installed."
	}
}
catch {
	"[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) | Out-File C:\Logs\HanaStudio_errors.txt -Append
	$_ | Out-File C:\Logs\HanaStudio_errors.txt -Append
}
