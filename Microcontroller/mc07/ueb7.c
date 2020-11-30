#include<avr/io.h>
#include<stdlib.h>
#include<avr/interrupt.h>
#include<avr/pgmspace.h>

/*Dieses Programm zaehlt auf zwei Siebensigmentanzeigen 
von 0 bis 99 und leuft dann wieder nach null ueber
@autor danil, tobi
*/


volatile uint32_t zeit_laeuft;

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


/*interrupt zur kontrolle der zaehlgeschwindigkeit*/
ISR(TIMER0_COMPA_vect){
    if(zeit_laeuft){
        zeit_laeuft--;
    }
}


// internes schieberegister benutzen
void send(uint8_t sev) { 
  USIDR=sev;    //zuweisen aufs daten register
  USISR=(1<<USIOIF);    //overflow flag setzten 
  do
    {
        // im usi controll register setzten der flags fuer
        // USIWM0 <= auf Three-wire mode einstellen
        // USICS1 <= externe clock benutzen "kein plan funktioniert intern nicht"
        // USICLK <= internen vierbit counter bei jeder flanke erhoehen um am ende 
        //           overflow flag auszuloesen
        // USITC <= togeln des clock bits 
    USICR=(1<<USIWM0)|(1<<USICS1)|(1<<USICLK)|(1<<USITC);
    }
  while (!(USISR & (1<<USIOIF))); // abfragen ob overflowflag gesetzt...? 
}


// zweistelliges schieben (16 bit) und schreiben auf ausgang vom externen schieberegister
void newnumber(uint8_t count, uint8_t  countz){
	send(countz);
	send(count);
	PORTB ^= 1;
	PORTB ^= 1;
}


int main(void){
    uint8_t count = 0, countz = 0;
	// Initialisieren


	OCR0A = 249; //Bis wohin soll gezaehlt werden 
	TCCR0A |=(1<<WGM01); //Bestimmt die zaehlweise des Timers
	TIMSK |=(1<<OCIE0A); //bestimmt die interrupts die ausfuerbar sind 
						 //in diesem fall der "Timer/counter0 compare Match A" 	
	TCCR0B |=(1<<CS00);//bestimmt ob ein interner bzw. externer takt fuer den timer benutzt werden soll
					  //und mit welchem taktteiler benutzt werden soll
					  //ausschlieslich nulltes bit gesetzt bedeutet keinen Taktteiler.

	sei(); //Globale iterrupt wird aktiviert... (enabelt)
	DDRB    |= 0b11000001; //pins PORTB als ausgang definieren

	while(1){

	
    newnumber(pgm_read_byte(&tabelle[count]), pgm_read_byte(&tabelle[countz]));

	if (count==15){ 		
		count=0;
		if (countz==15){				
			countz = 0;
		} else{
        	countz++;
		}
	}else{			
		count++;
	}


      zeit_laeuft=2000; //auskontern von nicht entpraellten schaltern
      while(zeit_laeuft);

	}
	return 0;//rueckgabewert wird NIEMALS erreicht^^
}

