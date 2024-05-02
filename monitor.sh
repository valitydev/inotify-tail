#!/bin/bash

# directory to monitor
MONITOR_DIR=${1:-"/var/log/audit"}

process_file() {
  local file="$1"
  iconv -s -t utf-8 $file
  rm -f "$file"
}

process_path() {
  local path="$1"
  if [ -f "$path" ]; then
    process_file "$path"
  elif [ -d "$path" ]; then
    for entry in "$path"/*; do
      if [ -f "$entry" ]; then
        process_file "$entry"
      elif [ -d "$entry" ]; then
        process_path "$entry"
      fi
    done
    
    # remove dirs older than 2 mins
    find "${MONITOR_DIR}" -mindepth 1 -empty -mmin +2 -delete -type d
  fi
}

export -f process_file

# read already existing files if any
find ${MONITOR_DIR} -type f -exec bash -c 'process_file "$0"' {} \;

# monitor directory and its subdirectories for new files
inotifywait -q -m -r -e create --format '%w%f' "${MONITOR_DIR}" | while read path; do
  process_path "$path" &
done