import subprocess
import os
import os.path
import tkinter
import joblib
import getpass

user_name = str(getpass.getuser())
git_path = "./git/bin/git.exe"
rutk_gui_path = "./Ru-Toolkit.exe"


subprocess.run([f"{git_path} clone https://github.com/ehristoforu/Russian-Toolkit.git ."], shell=True)

subprocess.run([f"{git_path} pull"], shell=True)

if not os.path.exists(f"C:/Users/{user_name}/AppData/outline/rutk-data.txt"):
    try:
        if os.path.exists(f"C:/Users/{user_name}/AppData/outline"):
            os.rmdir(f"C:/Users/{user_name}/AppData/outline")
        os.mkdir(f"C:/Users/{user_name}/AppData/outline")
        subprocess.run([f"{git_path} clone -b outlinedata https://github.com/ehristoforu/Russian-Toolkit.git ."], shell=True)
    except:
        print("RuTK Error with deleting outline old folder from AppData.")

subprocess.Popen(rutk_gui_path)