#!/usr/bin/env python

import sys
import csv
import os
import templates as t

_USAGE = """Usage: linker.py <file1> <file2> <file3> ...
    file1, file2, file3 - LUA scripts with objectives

Example:
    linker.py farm.lua defensive.lua offensive.lua recovery.lua
"""

def print_usage(usage):
  sys.stderr.write(usage)
  sys.exit(1)

def print_header():
  sys.stdout.write(t.HEADER)

def print_footer():
  sys.stdout.write(t.FOOTER)

def print_strategy_header(filename):
  header = t.STRATEGY_HEADER
  header = header.replace('<0>', os.path.splitext(os.path.basename(filename))[0])
  sys.stdout.write(header)

def print_strategy_footer():
  sys.stdout.write(t.STRATEGY_FOOTER)

def link_file(filename):
  print_strategy_header(filename)

  with open(filename, "rU") as file_obj:
    lines = file_obj.readlines()[5:-3]

    for line in lines:
      sys.stdout.write(line)

  print_strategy_footer()

def main():
  if len(sys.argv) < 2:
    print_usage(_USAGE)

  print_header()

  for filename in sys.argv[1:]:
    link_file(filename)

  print_footer()

if __name__ == '__main__':
  main()
