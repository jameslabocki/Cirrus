#CirrusListTemplates.bat
#One-liner that calls CirrusListTemplates.ps1 because calling powershell directly from Cygwin does not work
powershell -NonInteractive -command "& 'C:\Program Files (x86)\RedHat\RHEVManager\RHEVM Scripting Library\CirrusListTemplates.ps1' %1 "
