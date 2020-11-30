#!/bin/sh

clear
nasm -f elf64 -g -F dwarf "$1.asm" && \
ld -o "$1" "$1.o" && gdb "$1"