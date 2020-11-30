/*Datenname     : Blinker 2.0 
  Art           : Hauptprogram
  Beschreibung  : Bringt eine LED zum blinken
  Erstelt       : Danil Arapkaev, Tobias Schrittenlacher 
  Bearbeitet am : 24.04.2019*/

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>


volatile unsigned int zeit;
volatile unsigned char zeit_laeuft; //als boolean benutzte variable

/*interuppt funktion*/
ISR (TIMER0_COMPA_vect){
	if(zeit)zeit--;
	else zeit_laeuft = 0;
}


void warte(void){
	zeit_laeuft = 1;
	while (zeit_laeuft); //warten auf interrupt
}


int main(void){
	// Initialisieren
	OCR0A = 249; //Bis wohin soll gezaehlt werden 
	TCCR0A |=(1<<WGM01); //Bestimmt die zaehlweise des Timers
	TIMSK |=(1<<OCIE0A); //bestimmt die interrupts die ausfuerbar sind 
						 //in diesem fall der "Timer/counter0 compare Match A" 	
	TCCR0B |=(1<<CS00);//bestimmt ob ein interner bzw. externer takt fuer den timer benutzt werden soll
					  //und mit welchem taktteiler benutzt werden soll
					  //ausschlieslich nulltes bit gesetzt bedeutet keinen Taktteiler.

	sei(); //Globale iterrupt wird aktiviert... (enabelt)
	DDRB |= (1 << PB0); //pin pb0 als ausgang definieren
	PORTB |= (1 << PB0);//inizialisierung des pins
	
	while(1){
		PORTB ^= (1 << PB0); //toggeln des led pinns
        zeit = 20000;//dauer der zeitverzoegerung im interrupt
	    warte;	
	}
}
/* 
-Wie schnell blickt die Led hier?
Antwort: in diesem Fall => 10^-6*250*20000= 5 Sekunden
-Wie kann die Blinkzeit verändert werden?
Antwort: Indem man die Variabel zeit verändert.
-Wie genau ist die Blinkzeit?
Antwort: Hartware bedingte Abweichung von +-10%
*/
