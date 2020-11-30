#include<avr/io.h>
#include<stdlib.h>
#include<avr/interrupt.h>

/*Dieses Programm zaehlt auf einer einzelnen Siebensigmentanzeige 
von 0 bis 9 und leuft dann wieder nach null ueber
*/

volatile uint32_t zeit;
volatile uint8_t zeit_laeuft;


/*interrupt zur kontrolle der zaehlgeschwindigkeit*/
ISR(TIMER0_COMPA_vect){
	if(zeit)zeit--;
	else zeit_laeuft = 0;
}


/*uebersetzung von dezimalzahlen auf sieben sigmentcode*/
/*uint8_t uebersetzung(uint8_t count){
	switch (count){
		case 0:
		    return 0b11000000;
		case 1:
		    return 0b11111001;
		case 2:
		    return 0b10100100;
        case 3:
		    return 0b10110000;
        case 4:
		    return 0b10011001;
        case 5:
		    return 0b10010010;
        case 6:
		    return 0b00000010;
        case 7:
		    return 0b11111000;
		case 8:
		    return 0b10000000;
		case 9:
		    return 0b10010000;
	}
}
*/


/*funktion die auf den interrupt wartet*/
void warte(uint32_t nerven){
	zeit = nerven;
	zeit_laeuft = 1;
	while(zeit_laeuft);
}


int main(void){
	uint8_t tabelle[10];
	uint8_t count =0;
	// Initialisieren
	tabelle[0] = 0b11000000;
	tabelle[1] = 0b11111001;
	tabelle[2] = 0b10100100;
	tabelle[3] = 0b10110000;
	tabelle[4] = 0b10011001;
	tabelle[5] = 0b10010010;
	tabelle[6] = 0b00000010;
	tabelle[7] = 0b11111000;
	tabelle[8] = 0b10000000;
	tabelle[9] = 0b10010000;

    OCR0A = 249; //Bis wohin soll gezaehlt werden 
	TCCR0A |=(1<<WGM01); //Bestimmt die zaehlweise des Timers
	TIMSK |=(1<<OCIE0A); //bestimmt die interrupts die ausfuerbar sind 
						 //in diesem fall der "Timer/counter0 compare Match A" 	
	TCCR0B |=(1<<CS00);//bestimmt ob ein interner bzw. externer takt fuer den timer benutzt werden soll
					  //und mit welchem taktteiler benutzt werden soll
					  //ausschlieslich nulltes bit gesetzt bedeutet keinen Taktteiler.

	sei(); //Globale iterrupt wird aktiviert... (enabelt)
	DDRB |= 255; //pin pb0 als ausgang definieren
	PORTB |= 255;//inizialisierung des pins
	
	

	while(1){
		PORTB = tabelle[count];
		if (count==9){
			count=0;
		}else{
			count++;
		}
		warte(2000);
	}

	return 0;//rueckgabewert wird NIEMALS erreicht^^
}
