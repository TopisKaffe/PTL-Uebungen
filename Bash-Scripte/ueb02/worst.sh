#!/bin/sh

#sh skript zur sortierung einer reingepipten textdatei

#Autoren Tobias Schrittenlacher / Timo Templin

#-i gross-kleinschreibung ignorieren
#-v	invertierte Suchkriterien
#-h	keine dateinamen-Ausgabe (in diesem fall unnoetig)
grep -i -v -h "<failed>" | \

#-u alle doppelten zeilen eliminieren
sort -u |\
#-r sortieren in absteigender reihenfolge 
#-n numerisch sortieren nicht nach stringcompare
#-t spalten trenzeichen festlegen auf ";"
#-k Sortieren nach bestimmten spalten 
sort -r -n -t ";" -k 3,3 -k 1,1 |\

#tee "$1" in uebergebene datei schreiben 
#tail -n 1 die letzte zeile rausgreifen
tee "$1" | tail -1 | \

#-d trennzeichen fuer spalten festlegen auf ";"
#-f 2 inhalt der zweiten spalte ausgeben
cut -d ";" -f 2 