import subprocess
import os
import tkinter
import joblib

git_path = "./git/bin/git.exe"
rutk_gui_path = "./Ru-Toolkit.exe"

subprocess.run([f"{git_path} clone https://github.com/ehristoforu/Russian-Toolkit.git ."], shell=True)

subprocess.run([f"{git_path} pull"], shell=True)

subprocess.Popen(rutk_gui_path)