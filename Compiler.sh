#!/bin/bash 

files=$(ls *.asm 2>/dev/null)

selected_file=$(dialog --title "File for Compilation" --menu "Files in this directory" 15 50 10 $(for f in $files; do echo "$f $f"; done) 2>&1 >/dev/tty) 

if [ $? -eq 0 ]; then 
  clear
  output_file="${selected_file%.asm}"

  nasm -f elf64 "$selected_file" -o "$output_file.o" 
  ld "$output_file.o" -o "$output_file"
  clear 
  Good_ending=$(dialog --title "Compiled as $output_file" --menu "What to do next?" 11 65 4 \
    1 "Exit" \
    2 "Run ./$output_file" \
    3 "Ater run program delete it and file .o" \
    4 "Open in Vim" 2>&1 >/dev/tty) 
  case $Good_ending in
    1) clear && echo "Exit without actions";;
    2) clear && ./"$output_file" ;;
    3) clear && ./"$output_file" && rm "$output_file.o" "$output_file" ;;
    4) clear && vim "$selected_file";;
  esac 
else 
  clear
fi
