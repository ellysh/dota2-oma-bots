#!/bin/bash -x

set -e

CSV_DIR="database/csv"
DICTIONARY="dictionary.txt"
FIRST_RUN=0

./validator.py $CSV_DIR/code_snippets.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/moves.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/objectives.csv $DICTIONARY $FIRST_RUN

sort -u -o $DICTIONARY $DICTIONARY
