#!/bin/sh

#lister
#erstellt ein verzeichnis "info" und eine datei "mytextfiles.txt" 
#in der alle dateien und verzeichnisse aufgelistet sind die auf .txt enden.
#Autoren Tobias Schrittenlacher / Timo Templin

mkdir -p info ; ls *.txt > info/mytextfiles.txt