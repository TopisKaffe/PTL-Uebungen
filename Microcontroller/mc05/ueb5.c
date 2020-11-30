#include<avr/io.h>
#include<stdlib.h>
#include<avr/interrupt.h>
#include<avr/pgmspace.h>

/*Dieses Programm zaehlt auf zwei Siebensigmentanzeigen 
von 0 bis 99 und leuft dann wieder nach null ueber
@autor danil, tobi
*/

volatile uint32_t zeit;
volatile uint8_t zeit_laeuft;
volatile uint8_t leuchtzeit = 20;
volatile uint8_t ledzeit;
volatile uint8_t count = 0, countz = 0;

volatile uint8_t tabelle[16]PROGMEM={0b11000000,0b11111001,0b10100100,0b10110000,
                                    0b10011001,0b10010010,0b00000010,0b11111000,
                                    0b10000000,0b10010000,0b10001000,0b11100000,
                                    0b10110001,0b11000010,0b10110000,0b10111000};


    /*
	[0] = 0b11000000
	[1] = 0b11111001
	[2] = 0b10100100
	[3] = 0b10110000
	[4] = 0b10011001
	[5] = 0b10010010
	[6] = 0b00000010
	[7] = 0b11111000
	[8] = 0b10000000
	[9] = 0b10010000
	[10] = 0b10001000
	[11] = 0b11100000
	[12] = 0b10110001
	[13] = 0b11000010
	[14] = 0b10110000
	[15] = 0b10111000
    */


/*interrupt zur kontrolle der zaehlgeschwindigkeit*/
ISR(TIMER0_COMPA_vect){
	if(zeit)zeit--;
	else zeit_laeuft = 0;

	if (ledzeit==(leuchtzeit*2)){
		PORTD = 0;
		PORTB = pgm_read_byte(&tabelle[count]);	
		PORTD = 1;
		ledzeit=0;
	}else if (ledzeit==leuchtzeit){	
		PORTD = 0;
		PORTB = pgm_read_byte(&tabelle[countz]);
		PORTD = 2;
		ledzeit++;
	}else{
		ledzeit++;
	}
}



/*delay*/
void warte(uint32_t nervig){
	zeit = nervig;
	zeit_laeuft = 1;
	while(zeit_laeuft);
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

	ledzeit=0;
	DDRB |= 255; //pins PORTB als ausgang definieren
	PORTB = tabelle[0];//inizialisierung der pins
	DDRD |= 3;
	PORTD = 3;

	while(1){
	
	//zaehlen und speicher beschreiben
	
	if (count==9){ 		
			count=0;
			if (countz==9){				
				countz = 0;
			} else{
				countz++;
			}
		}else{			
			count++;
		}
		//delay
		warte(2000);
	}

	return 0;//rueckgabewert wird NIEMALS erreicht^^
}
