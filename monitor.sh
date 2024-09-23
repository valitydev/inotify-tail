#!/bin/bash

# directory to monitor
MONITOR_DIR=${1:-"/home/ivanovi/inotif_test/test_dir"}

process_file() {
  local file="$1"
  iconv -s -t utf-8 $file
  rm -f "$file"
}

export -f process_file

while (true); do
  find ${MONITOR_DIR} -type f -exec bash -c 'process_file "$0"' {} \;
  find "${MONITOR_DIR}" -mindepth 1 -empty -mmin +2 -delete -type d
  sleep 5
done
