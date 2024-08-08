import subprocess
import os
from joblib import Memory

memory = Memory("./.cache")

@memory.cache
def telegram():
    os.chdir('telegram')

    subprocess.run("Telegram.exe", shell=True)

telegram()