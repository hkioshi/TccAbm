/**
* Name: Main
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/

model Main
import "agents/Mosquito.gaml"
import "agents/Paciente.gaml"
import "agents/Ambiente.gaml"
import "agents/Poca.gaml"

import "globals/globals.gaml"


grid ambiente width: 20 height: 20 
{

    rgb cor <- #green;
	
    aspect default 
    {
        draw shape color: cor;
    }
}
/* Insert your model definition here */



experiment MeuExperimento type: gui {
	
	 action clicar 
	 {

        point pos <- #user_location;

        create mosquito number: 100 
        {
        	poca_natal <- pos;
            location <- pos;
        }
    }
    output 
    {

        display mundo type: 2d 
        {
            grid ambiente;
            species mosquito;
            species pessoa;
            species poca;
            
            event #mouse_down action: clicar;
		            
		}


    	monitor "Quantidade" value: length(pessoa);
    	monitor "Quantidade mosquito" value: length(mosquito);
    	
    	monitor "Dia" value: dia;
//   	 	display grafico type: java2D {
//	    chart "Pessoas por ciclo" type: series {
//		        data "Pessoas" value: length(pessoa);
//		    }
//		}
    }
  }
    

