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

def get_value(line, index):
  value = line[index].strip().replace("\n"," ")
  return value if value else 'nil'

def get_actions(reader):
  for line in reader:
    if line[4]:
      action = t.ACTION
      action = action.replace('<' + str(4) + '>', get_value(line, 4))
      return action

def get_moves(reader):
  for line in reader:
    if line[2]:
      move = t.MOVE
      move = move.replace('<' + str(2) + '>', get_value(line, 2))
      move = move.replace('<' + str(3) + '>', get_value(line, 3))
      actions = get_actions(reader)
      move = move.replace('<ACTIONS>', actions)
      return move

def print_objective(line, reader):
  if line[0]:
    objective = t.OBJECTIVE
    objective = objective.replace('<' + str(0) + '>', get_value(line, 0))
    objective = objective.replace('<' + str(1) + '>', get_value(line, 1))
    moves = get_moves(reader)
    objective = objective.replace('<MOVES>', moves)
    sys.stdout.write(objective)

def parse_lines(reader):
  skip_header_lines(reader)

  for line in reader:
    print_objective(line, reader)

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
