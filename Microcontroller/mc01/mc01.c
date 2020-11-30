#include <avr/io.h>
#include <stdlib.h>



int main(void){
	DDRB |= 1;
	PORTB |= 1;
	uint64_t i=0 ,count= 5000 ,k=0;

	while(1){	
		if((i+k)>count){
			PORTB ^= 1;
			i = 0;
            k+=5;
		}else{
			i++;
		}
	}
}
