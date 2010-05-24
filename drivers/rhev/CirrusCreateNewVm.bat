#CirrusCreateNewVm.bat
#One-liner that calls CirrusCreateNewVm.ps1 because calling powershell directly from Cygwin does not work
powershell -NonInteractive -command "& 'C:\Program Files (x86)\RedHat\RHEVManager\RHEVM Scripting Library\CirrusCreateNewVm.ps1' %1 %2 %3 %4"
