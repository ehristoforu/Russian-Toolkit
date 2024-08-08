import tkinter as tk
from tkinter import font
import subprocess

# Функция для запуска exe-файлов
def run_exe(file_path):
    subprocess.Popen(file_path)

# Создание главного окна
root = tk.Tk()
root.title("Russian Toolkit")
root.geometry("400x570")
root.configure(bg="#2c3e50")

header_font = font.Font(family="Arial", size=24, weight="bold")
button_font = font.Font(family="Arial", size=14, weight="bold")

header = tk.Label(root, text="Russian Toolkit", font=header_font, bg="#2c3e50", fg="#ecf0f1")
header.pack(pady=20)

def create_button(text, command):
    button = tk.Button(root, text=text, font=button_font, bg="#3498db", fg="#ecf0f1", command=command)
    button.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

exe_paths = [
    "CentBrowser.exe",
    "OutlineVPN.exe",
    "GoodByeDPI.exe",
    "DNSJumper.exe",
    "TelegramPortable.exe"
]

# Создание кнопок для запуска exe-файлов
for i, path in enumerate(exe_paths, 1):
    create_button(f"{exe_paths[i-1][:-4]}", lambda p=path: run_exe(p))

root.mainloop()
