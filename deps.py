#!/usr/bin/env python

import os
import glob
from tools.Coffee import *
from tools.Watcher import Watcher

js_dir = './js'
coffee_dir = './coffee'

js_files = [js_dir, 'deps/box2d']
js_files += glob.glob('deps/easel/src/easeljs/**/')

def doCoffee(diff):
  removeOrphanedJs(diff)
  coffee(js_dir, coffee_dir)
  generate_deps('./deps/closure-library', js_files, 'js/deps.js')

Watcher('./coffee', '*.coffee').watch(doCoffee)
