#Remove this section once the default cmdlet problem is fixed in this environment
######
#$configDirectory = "C:\Program Files (x86)\RedHat\RHEVManager\RHEVM Scripting Library\"
#$currAppDomain = [System.AppDomain]::CurrentDomain
#$currAppDomain.SetData("APP_CONFIG_FILE",$configDirectory  + "RHEVMCmd.dll.config") 
#Add-PSSnapin RHEVMPSSnapin
#$global:ps = get-command -pssnapin RHEVMPSSnapin
######

$templatename = $args[0]

#$templatename = mrgexectemplate
#Login

Login-User admin 100yard- WORKGROUP


#Select Template
Select-Template ("name=$templatename")

#Select-Template