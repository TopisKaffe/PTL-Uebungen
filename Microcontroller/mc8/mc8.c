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
                                    0b10000000,0b10010000,0b10001000,0b10000011,
                                    0b11000110,0b10100001,0b10000110,0b10001110};


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
	[11] = 0b10110000
	[12] = 0b10110001
	[13] = 0b11000010
	[14] = 0b10110000
	[15] = 0b10111000
    */


void transbyte(uint8_t data){
    UCSRB|= (1<<TXEN);
    while(!(UCSRA & (1<<UDRE)));

    UDR = data;
}



uint8_t resbyte(void){
    UCSRB|= (1<<RXEN); 
    while(!(UCSRA & (1<<RXC)));
    return UDR;
}



/*interrupt zur kontrolle der zaehlgeschwindigkeit*/
ISR(TIMER0_COMPA_vect){
  
    if(zeit_laeuft){
        zeit_laeuft--;
    }

    //wechseln zwischen beiden anzeigen
	if (ledzeit==(leuchtzeit*2)){ 
		PORTD   ^=8;
		PORTB   = pgm_read_byte(&tabelle[count]);	
		PORTD   |=4;
		ledzeit =0;
	}else if (ledzeit==leuchtzeit){	
		PORTD   ^=4 ;
		PORTB   = pgm_read_byte(&tabelle[countz]);
		PORTD   |=8;
	}
	ledzeit++;	
   
}



int main(void){
  

	// Initialisieren

	OCR0A  = 249; //Bis wohin soll gezaehlt werden 
	TCCR0A |=(1<<WGM01); //Bestimmt die zaehlweise des Timers
	TIMSK  |=(1<<OCIE0A); //bestimmt die interrupts die ausfuerbar sind 
						 //in diesem fall der "Timer/counter0 compare Match A" 	
	TCCR0B |=(1<<CS00);//bestimmt ob ein interner bzw. externer takt fuer den timer benutzt werden soll
					  //und mit welchem taktteiler benutzt werden soll
					  //ausschlieslich nulltes bit gesetzt bedeutet keinen Taktteiler.

	sei(); //Globale iterrupt wird aktiviert... (enabelt)

    
    UCSRA|=2;
    UBRRL=12;
	
    
    ledzeit =0;
	DDRB    |= 255; //pins PORTB als ausgang definieren
	PORTB   = pgm_read_byte(&tabelle[0]);//inizialisierung der pins
	DDRD    |= 12;   //PD2 & PD3 als ausgang definieren
	PORTD   |= 3<<2;  //pullup widerstaende aktivieren
    PORTD   |= 12;   //PD2 & PD3 aktivieren

	while(1){
        UCSRC |=  (3<<1);
      
        countz  =resbyte();
        
        transbyte(countz);
        count   =countz%10;
        countz  /=10;
        
      
        zeit_laeuft=3; //auskontern von nicht entpraellten schaltern
        while(zeit_laeuft);

	}
	return 0;//rueckgabewert wird NIEMALS erreicht^^
}
