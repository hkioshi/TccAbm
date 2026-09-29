/**
* Name: Ovo
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model Ovo

/* Insert your model definition here */
import "Mosquito.gaml"
import "Poca.gaml"



species ovo {

    int idade <- 0;
    poca poca_natal_ovo;

    action Envelhecer {
        idade <- idade + 1;
		poca pop <- poca_natal_ovo;

        if (idade > 10) {
			remove self from: pop.ovos;
        	
            create mosquito number: 1 {
                location <- pop.location;
                poca_natal <- pop.location;
            }

            do die;
        }
    }
}