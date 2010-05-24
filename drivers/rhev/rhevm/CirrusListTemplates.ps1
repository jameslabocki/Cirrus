#CirrusListTemplates.ps1 selects template 
#

$templatename = $args[0]

#Login
#Login-User username password DOMAIN
Login-User username password DOMAIN


#Select Template
Select-Template ("name=$templatename")
