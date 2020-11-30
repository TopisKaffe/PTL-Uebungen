#!/bin/sh

# pfcalc.sh ist ein skript welches als rudimentaerer 
# ganzzahlen Taschenrechner funktioniert.
# @ autor: Timo Templin, Tobias Schrittenlacher



# printH gibt die Usage aus  
printH () {
	cat << EOT
Usage:
pfcalc.sh -h | pfcalc.sh --help

  prints this help and exits

pfcalc.sh [-i | --visualize] NUM1 NUM2 OP [NUM OP] ...

  provides a simple calculator using a postfix notation. A call consists of
  an optional parameter, which states whether a visualization is wanted,
  two numbers and an operation optionally followed by an arbitrary number
  of number-operation pairs.

  NUM1, NUM2 and NUM are treated as integer numbers.

  NUM is treated in the same way as NUM2 whereas NUM1 in this case is the
  result of the previous operation.

  OP is one of:

    ADD - adds NUM1 and NUM2

    SUB - subtracts NUM2 from NUM1

    MUL - multiplies NUM1 and NUM2

    DIV - divides NUM1 by NUM2 and returns the integer result

    MOD - divides NUM1 by NUM2 and returns the integer remainder

  When the visualization is active the program additionally prints the
  corresponding mathematical expression before printing the result.
EOT
}



# Ya, guckt ob is ok. Wenn nich, dann macht Ausgabe, diggah
# mit annern worten fehlerausgabe wenn sie denn auftreten
isOk(){	
	case "$1" in
		142 )
		echo "Error: Division und Modulo durch 0 explodiert. DU NUTTÖÖÖÖ!!!" 1>&2
		printH 1>&2
		;;
		169 )
		echo "Error: Wat soll man mit den schwachsinns eingaben rechnen???" 1>&2
		printH 1>&2
		;;
	esac
	return "$1"
}


SECOND="0"			# zweiter operant
STRING="0"			# String fuer ausgabe wenn visualisation aktiviert ist
ADD_STRING="0"		# zweiter operant fuers string bauen
OP="0"				# operator fuer die verarbeitung und das string gebaue
VISU="0"			# flag ob visualisierungsoption gewaehlt wurde
SHITHAPPENS="0"		# variable fuer error codes		
RES="0"				# ergebnis variable


if [ "x$1" = "x--help" ] || [ "x$1" = "x-h" ]; then # abfrage ob hilfe angefordert wurde
	if [ $# = 1 ]; then
		printH
	else
		SHITHAPPENS=169	
	fi 
else
	if [ "x$1" = "x-i" ] || [ "x$1" = "x--visualize" ]; then  # abfrage ob visualisierung verlangt wurde
		VISU=1
		if [ $# -le 3 ]; then
			SHITHAPPENS=169	
		fi
		shift
	fi
	if [ $# -le 2 ] || [ $(($# % 2)) -eq 0 ]; then 
		SHITHAPPENS=169
	else
		RES="$1"
		STRING="$1"
		[ "$1" -lt 0 ] && STRING="($RES)"   # mit klammern umschliessen wenn negativ
		shift
		while [  $# -gt 1 ] && [ $SHITHAPPENS -eq 0 ]; do 
			case "$1" in  # einlesen von zahlen
			[0-9]* )
				SECOND="$1"
				ADD_STRING="$1"
				;;
			-[0-9]* )
				SECOND="$1"
				ADD_STRING="($1)"
				;;
				*  )
				SHITHAPPENS=169
				;;			
			esac
			case "$2" in 	# einlesen des operators
			ADD )
				OP="+"
				;;
			SUB )
				OP="-"
				;;
			MUL )
				OP='*'
				;;
			DIV )
				OP='/'
				;;
			MOD )
				OP='%'
				;;
				* )
			SHITHAPPENS=169
				;;	
			esac				
			shift ; shift
			if [ $SHITHAPPENS -eq 0 ]; then 
				if [ "$VISU" -eq 1 ]; then		#string bauen falls visualisierung gefordert
						STRING="($STRING$OP$ADD_STRING)"
				fi
				if [ "$OP" = '/' ] || [ "$OP" = '%' ] && [ $SECOND -eq 0 ]; then	# rechnung
					SHITHAPPENS=142
				else
					RES=$(($RES$OP$SECOND))
				fi
			fi
		done
		if [ $SHITHAPPENS -eq 0 ]; then # wenn kein fehler ausgabe nach geforderten kriterien
			if [ $VISU -eq 1 ]
			then
				echo $STRING
			fi
		echo $RES
		fi
	fi
fi
isOk $SHITHAPPENS # uebergabe der fehlercodes an fehler ausgabe