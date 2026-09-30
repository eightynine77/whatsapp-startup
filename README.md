# whatsapp startup
neat tool that runs whatsapp at startup and then close it.

# the script
you can download the batch file [here](https://raw.githubusercontent.com/eightynine77/whatsapp-startup/refs/heads/main/whatsapp-startup.bat)

# how to use
follow these steps:
1. copy the powershell code and save it as a `.bat` file (alternatively, you can just download it [here](https://github.com/eightynine77/whatsapp-startup/blob/main/whatsapp-startup.bat))
2. put the powershell file into windows' startup folder. the way you open the startup folder is by going to this directory if you want to apply to individual windows account: `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`  
   for all users, copy to this directory: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup`

and that's how to use it. when your windows machine boots up, the script should run.

# note
if you want to use the powershell script, make sure you allow powershell script execution or use a batch file as a launcher script to run the powershell script. windows by default doesn't allow you to run powershell scripts
