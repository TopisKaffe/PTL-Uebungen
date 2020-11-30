#!/bin/sh


nasm -f elf64 -g -F stabs "$1.asm"
ld -o "$1" "$1.o"