import subprocess
import os
from joblib import Memory

memory = Memory("./.cache")

@memory.cache
def browser():
    os.chdir('browser')

    subprocess.run("chrome.exe", shell=True)

browser()