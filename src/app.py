import platform
import subprocess
from datetime import datetime
from flask import Flask
app = Flask(__name__)

@app.route('/')
def info():
    pl = platform.platform()
    dt = datetime.now().strftime("%m/%d/%Y, %H:%M:%S")
    ip = (subprocess.run(['hostname', '-I'], stdout=subprocess.PIPE)).stdout.decode('utf-8')
    return f'Plaform: {pl}; Date & Time: {dt}; IP address: {ip}'

if __name__ == '__main__':
    app.run()

import subprocess

print(result.stdout.decode('utf-8'))