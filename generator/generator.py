#!/usr/bin/env python

import sys
import csv
import templates as t

_USAGE = """Usage: generator.py <in_file>
    in_file - input CSV file

Example:
    generator.py database/csv/objectives.csv
"""

_MAX_COLUMN = 4

def print_usage(usage):
  sys.stderr.write(usage)
  sys.exit(1)

def skip_header_lines(reader):
  reader.next()

def print_header():
  sys.stdout.write(t.HEADER)

def print_footer():
  sys.stdout.write(t.FOOTER)

def is_comment(string):
  return string[:2] == "--"

def get_value(line, index):
  value = line[index].strip().replace("\n"," ")
  return value if value else 'nil'

def print_objective(line):
  objective = t.OBJECTIVE_HEADER
  objective = objective.replace('<' + str(0) + '>', get_value(line, 0))
  sys.stdout.write(objective)
  return

def print_move(line):
  move = t.MOVE_HEADER
  move = move.replace('<' + str(1) + '>', get_value(line, 1))
  sys.stdout.write(move)
  return

def print_action(line):
  action = t.ACTION
  action = action.replace('<' + str(2) + '>', get_value(line, 2))
  sys.stdout.write(action)
  return

IS_FIRST_OBJECTIVE = True
IS_FIRST_MOVE = True

def print_element(line):
  global IS_FIRST_OBJECTIVE
  global IS_FIRST_MOVE

  if line[0] and not is_comment(line[0]):
    if not IS_FIRST_OBJECTIVE:
      sys.stdout.write(t.MOVE_FOOTER)
      sys.stdout.write(t.OBJECTIVE_FOOTER)

    IS_FIRST_OBJECTIVE = False
    IS_FIRST_MOVE = True
    print_objective(line)

  if line[1] and not is_comment(line[1]):
    if not IS_FIRST_MOVE:
      sys.stdout.write(t.MOVE_FOOTER)

    IS_FIRST_MOVE = False
    print_move(line)

  if line[2] and not is_comment(line[2]):
    print_action(line)

def parse_lines(reader):
  skip_header_lines(reader)

  for line in reader:
    print_element(line)

  sys.stdout.write(t.MOVE_FOOTER)
  sys.stdout.write(t.OBJECTIVE_FOOTER)

def parse_csv_file(filename):
  with open(filename, "rU") as file_obj:
    reader = csv.reader(file_obj, delimiter=';')
    parse_lines(reader)

def main():
  if len(sys.argv) == 2:
    filename = sys.argv[1]
  else:
    print_usage(_USAGE)

  print_header()

  parse_csv_file(filename)

  print_footer()

if __name__ == '__main__':
  main()
