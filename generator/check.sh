#!/bin/bash -x

set -e

CSV_DIR="database/csv"
DICTIONARY="dictionary.txt"
FIRST_RUN=0

./validator.py $CSV_DIR/buy.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/farm.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/recovery.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/offensive.csv $DICTIONARY $FIRST_RUN
./validator.py $CSV_DIR/defensive.csv $DICTIONARY $FIRST_RUN

sort -u -o $DICTIONARY $DICTIONARY
