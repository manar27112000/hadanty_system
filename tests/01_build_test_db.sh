#!/bin/bash
# Rebuilds a scratch database (Hadanty_Test) from the sql/ files and reports errors per file.
# It never touches the real Hadanty database.
# Usage (Git Bash, from the project root):  bash tests/01_build_test_db.sh
# Then run tests/02_business_rule_checks.sql and tests/03_negative_tests.sql against Hadanty_Test
# with sqlcmd using -I (QUOTED_IDENTIFIER ON), e.g.:
#   sqlcmd -S localhost -E -C -I -d Hadanty_Test -W -i tests/02_business_rule_checks.sql
SQLCMD="${SQLCMD:-sqlcmd}"
SERVER="${SERVER:-localhost}"
DIR="$(cd "$(dirname "$0")/../sql" && pwd)"
TMP="$(mktemp -d)"; cd "$TMP"
"$SQLCMD" -S "$SERVER" -E -C -Q "IF DB_ID('Hadanty_Test') IS NOT NULL BEGIN ALTER DATABASE Hadanty_Test SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE Hadanty_Test; END; CREATE DATABASE Hadanty_Test;" >/dev/null 2>&1
for f in 02_Core 03_Academic 04_Attendance_Pickup 05_Reports_Assessment 06_Health_Safety 07_Finance 08_Transportation 09_Events_Notifications 10_Settings_Audit 11_Constraints 12_Indexes 13_Seed_Data; do
  sed 's/USE Hadanty;/USE Hadanty_Test;/I' "$DIR/$f.sql" > "$f.sql"
  out=$("$SQLCMD" -S "$SERVER" -E -C -d Hadanty_Test -b -i "$f.sql" 2>&1 | grep -v "^Changed database context" | grep -v '^\s*$')
  if echo "$out" | grep -qE "Msg|Sqlcmd|rror"; then echo "== $f: ERRORS"; echo "$out" | grep -E "Msg|Sqlcmd" | head -6; else echo "== $f: OK"; fi
done
"$SQLCMD" -S "$SERVER" -E -C -d Hadanty_Test -h -1 -W -Q 'SET NOCOUNT ON; SELECT CONCAT(COUNT(*), '' tables'') FROM sys.tables'
