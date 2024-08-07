import subprocess
import os
from joblib import Memory

memory = Memory("./.cache")

@memory.cache
def dns():
    os.chdir('dns')

    subprocess.run("DnsJumper.exe", shell=True)

dns()