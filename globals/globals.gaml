/**
* Name: global
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model globals

import "../agents/Mosquito.gaml"
import "../agents/Paciente.gaml"
import "../agents/Ambiente.gaml"
import "../agents/Poca.gaml"

/* Insert your model definition here */


global 
{
	
	int quantidade <- 1000;
	string a <- "sadasd";
	point p <- {0,0};
	int dia <- 0;
	reflex evento when: every(24 #cycles) 
	{
    	dia <- dia + 1;
		ask pessoa {
        	do Envelhecer;
    	}
    	ask mosquito {
        	do Envelhecer;
    	}
    	ask (mosquito where (each.sexo = "Femea")) {
		    do Picar;
		}
		
		
    	
	}	
	
	init{
		create pessoa number:quantidade;
		create poca number: 10;
		
	}
		
}