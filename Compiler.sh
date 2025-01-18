#!/bin/bash 

files=$(ls *.asm 2>/dev/null)

selected_file=$(dialog --title "File to compile" --menu "Files in current directory" 15 50 10 $(for f in $files; do echo "$f $f"; done) 2>&1 >/dev/tty) 

if [ $? -eq 0 ]; then 
  clear
  output_file="${selected_file%.asm}"

  nasm -f elf64 "$selected_file" -o "$output_file.o" 
  ld "$output_file.o" -o "$output_file"
  clear 
  Good_ending=$(dialog --title "Compiled as $output_file" --menu "What program need to do now?" 10 40 2 \
    1 "Exit" \
    2 "run $output_file" \
    3 "Open in Vim" 2>&1 >/dev/tty) 
  case $Good_ending in
    1) clear && echo "Exit";;
    2) clear && ./"$output_file" ;;
    3) clear && vim "$selected_file";;
  esac 
else 
  clear
fi

