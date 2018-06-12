#!/bin/bash -x

set -e

CSV_DIR="database/csv"
RESULT_DIR="../bots/database"

./ods2csv.sh

./generator.py OBJECTIVES 4 $CSV_DIR/objectives.csv > $RESULT_DIR/objectives.lua

./generator.py MOVES 2 $CSV_DIR/moves.csv > $RESULT_DIR/moves.lua

./generator.py CODE_SNIPPETS 2 $CSV_DIR/code_snippets.csv > $RESULT_DIR/code_snippets.lua

./check.sh
