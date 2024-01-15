Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "d:\每5秒检测一次进程是否存在.bat" & Chr(34), 0
Set WshShell = Nothing
