#!/bin/sh

clear
nasm -f elf64 -g -F dwarf "$1.asm" && echo "OK"
fpc -gs "$2.lpr" && echo "OK"

