#Remove this section once the default cmdlet problem is fixed in this environment
######
#$configDirectory = "C:\Program Files (x86)\RedHat\RHEVManager\RHEVM Scripting Library\"
#$currAppDomain = [System.AppDomain]::CurrentDomain
#$currAppDomain.SetData("APP_CONFIG_FILE",$configDirectory  + "RHEVMCmd.dll.config") 
#Add-PSSnapin RHEVMPSSnapin
#$global:ps = get-command -pssnapin RHEVMPSSnapin
######

#Script to get the Next Node Name for a MRG Execute Node


#Login

Login-User admin 100yard- WORKGROUP


#Select VM

Select-Vm ("name=*")
