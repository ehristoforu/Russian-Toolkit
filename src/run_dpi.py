import subprocess
import os
from joblib import Memory

memory = Memory("./.cache")

@memory.cache
def dpi():
    os.chdir('goodbyedpi')

    subprocess.run(["0_russia_update_blacklist_file.cmd"], shell=True)
    subprocess.run(["1_russia_blacklist.cmd"], shell=True)

dpi()