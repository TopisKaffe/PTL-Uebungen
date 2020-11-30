#! /bin/sh

##
# ein skript zur analyse von latex Dateien
# fuer weitere informationen (optionen und aufrufsyntax) 
# bitte mit parameter -h oder --help starten
# autoren Tobias Schrittenlacher, Timo Templin

##
# gibt die usage auf stdout aus ohne eingabe parameter
#
printH(){
cat << EOT
Usage:
latexanalyse.sh -h | latexanalyse.sh --help

  prints this help and exits

latexanalyse.sh INPUT OPTION

  INPUT is a valid latex-File (.tex)

  and OPTION is one of

  -g, --graphics      prints a list of all included graphics

  -s, --structure     prints the structure of the input file

  -u, --usedpackages  prints a list of the used packages and their options
EOT
}

##
# param $1 fehlercode 
# param $2 nur anzugeben wenn datei fehler auftreten
# out fehlerstring und usage auf std error
#
exiTerror(){
	case "$1" in
		130 ) echo "Error: falsche parameter anzahl" 1>&2 ; printH 1>&2 ;;
		131 ) echo "Error: datei" "$2" "ist nicht lesbar oder existiert nicht" 1>&2 
			  printH 1>&2 ;;
		132 ) echo "Error: ungueltige option" 1>&2 ; printH 1>&2 ;;		
		133 ) echo "Error: die datei" "$2" "hat den falschen typ" 1>&2  
			  printH 1>&2 ;;	
	esac
	exit "$1"
}

##
# sucht alle eingefuegten bilder und und gibt ihre Namen auf stdout aus
# param $1 die zu ueberpruefende latexdatei
# out die Namen der eingefuegten bilder
#
pinUps_XD(){
	cat "$1" | cut -d "%" -f 1 | tr "\n" " " | \
	grep -E "\\\includegraphics[^{]*{[^}]*}" -o |\
	sed 's/\\\includegraphics[^{]*{\([^}]*\)}/\1/'
}

##
# sucht die formatierung der uebergebenen latex datei herraus und gibt diese 
# auf stdout aus
# param $1 die zu ueberpruefende latexdatei
# out formatierte ausgabe der kapitel und unterabteilungen auf stdout
#
thunderStruc(){
	cat "$1" | cut -d "%" -f 1 | tr "\n" " " |\
	grep -E -e "\\\subsection[*]?{[^{]*}" -e "\\\section[*]?{[^{]*}" \
	-e "\\\chapter[*]?{[^{]*}" -o |\
	sed -r 's/\\chapter[*]?/ /;s/\\subsection[*]?/     |-- /;
	s/\\section[*]?/ |-- /;s/[{}]//g'
}

##
# sucht alle benutzten packages heraus und gibt diese alfabetisch auf stdout aus
# param $1 die zu ueberpruefende latexdatei
# out sortierte ausgabe der packete auf stdout
#
packetDienstDHL(){
	cat "$1" | cut -d "%" -f 1 | tr "\n" " " | sed 's/ //g' | \
	grep -E "\\\usepackage[^}]*}" -o |\
	sed 's/\\\usepackage//;s/\(\[.*\]\)\({.*}\)/\2\1/;s/[]{[]//g;s/}/:/' | sort 
}

##
# Haupt programm
# strucktur zum abfangen von fehlerhaften dateien und falscher aufrufsyntax
# und zusaetzlich aufruf der funktionen nach den im parameter $2 
# uebergebenen optionen
#
if [ "$1" = "-h" -o "$1" = "--help" ]; then
	[ $# -ne 1 ] && exiTerror 130
	printH
else 
	test ! -r "$1" && exiTerror 131 "$1"
	case "$1" in
		*.tex )
			[ $# -ne 2 ] && exiTerror 130
			case "$2" in
				-g | --graphics ) pinUps_XD "$1" ;;
				-s | --structure  ) thunderStruc "$1";;
				-u | --usedpackages ) packetDienstDHL "$1";;
				* ) exiTerror 132 ;;			
			esac
			;;
		*)	exiTerror 133 "$1";;	
	esac
fi