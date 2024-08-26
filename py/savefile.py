# -*- coding: utf-8 -*-

import os
import threading
import urllib.request
import pyotherside

def getdirs (dir):
    dirs = []
    dirs = dirs + next(os.walk(dir))[1]
    dirs[:] = [x for x in dirs if not x.startswith('.')]
    if os.path.abspath(dir) != os.getenv('HOME'):
        dirs.insert(0, "..")
    return dirs

def save (dir, name, url, filenam):
    req = urllib.request.Request(url, headers={'User-agent': 'curl/8.4.0-DEV'})
    with urllib.request.urlopen(req) as res:
        if res.getcode() == 200:
            f = open(os.path.abspath(dir) + "/" + name, 'wb')
            f.write(res.read())
            f.close()
            pyotherside.send(filenam, 'done')

def savefile (dir, name, url, filenam):
    t = threading.Thread(target=save, args=(dir, name, url, filenam))
    t.start()

