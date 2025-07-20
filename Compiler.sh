#!/bin/bash

files=$(ls *.asm 2>/dev/null)

selected_file=$(dialog --title "File for Compilation" --menu "Files in this directory" 15 50 10 $(for f in $files; do echo "$f $f"; done) 2>&1 >/dev/tty)

if [ $? -eq 0 ]; then
  clear
  output_file="${selected_file%.asm}"

  tmp_file=$(mktemp)

  nasm -f elf64 "$selected_file" -o "$output_file.o" 2>"$tmp_file"
  if [ $? -ne 0 ]; then
    echo "Error in nasm part(!):"
    cat $tmp_file
    rm $tmp_file
    exit 1
  fi

  ld "$output_file.o" -o "$output_file" 2>"$tmp_file"
  if [ $? -ne 0 ]; then
    echo "Error in ld part(!):"
    cat $tmp_file
    cat "$tmp_file"
    rm $tmp_file
    exit 1
  fi

  ./"$output_file"

  rm -rf "$output_file.o"
  rm -rf "$output_file"
fi
