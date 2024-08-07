import subprocess
import os
from joblib import Memory

memory = Memory("./.cache")

@memory.cache
def vpn():
    os.chdir('outline')

    subprocess.run("find_tap_device_name.bat", shell=True)
    subprocess.run("add_tap_device.bat", shell=True)
    subprocess.run("install_windows_service.bat", shell=True)
    subprocess.run("Outline.exe", shell=True)

vpn()