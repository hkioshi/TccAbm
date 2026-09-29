/**
* Name: global
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/

model globals

import "../agents/Mosquito.gaml"
import "../agents/Pessoa.gaml"
import "../agents/Ambiente.gaml"
import "../agents/Poca.gaml"

/* Insert your model definition here */


global 
{
	int temperatura;
	int mes <- 1;
	int quantidade <- 1000;
	int mortos_por_dengue <- 0;
	int dia <- 0;
	int chuva;
 	file subprefeituras_shapefile <- file("../Gis/subprefeitura_v2.shp");

    geometry shape <- envelope(subprefeituras_shapefile);


	
	reflex evento when: every(24 #cycles) 
	{

		if(dia > 30)
		{
			if(mes != 12)
			{
				mes <- mes + 1;
			}
			else
			{
				mes <- 1;
			}
		}
		
		ask pessoa {
        	do Envelhecer;
        	do Nascer;
    	}
    	
    	ask mosquito {
        	do Envelhecer;
    	}
    	ask (mosquito where (each.sexo = "Femea")) {
		    do Picar;
		}
		ask ovo {
			do Envelhecer;
		}

		float quantidade_chuva;
		switch mes 
		{
		    match 1 {
		        if (rnd(100.0) < 73.1) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 2 {
		        if (rnd(100.0) < 62.4) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 3 {
		        if (rnd(100.0) < 49.5) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 4 {
		        if (rnd(100.0) < 42.2) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 5 {
		        if (rnd(100.0) < 21.5) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 6 {
		        if (rnd(100.0) < 27.8) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 7 {
		        if (rnd(100.0) < 18.3) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 8 {
		        if (rnd(100.0) < 16.1) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 9 {
		        if (rnd(100.0) < 15.6) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 10 {
		        if (rnd(100.0) < 48.4) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 11 {
		        if (rnd(100.0) < 41.6) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		
		    match 12 {
		        if (rnd(100.0) < 53.8) {
		            quantidade_chuva <- rnd(0.0, 30.0);
		        } else {
		            quantidade_chuva <- 0.0;
		        }
		    }
		}
		
    	dia <- dia + 1;
    	temperatura <- rnd(15,35);
    	
    	ask poca
    	{
    		do Envelhecer(quantidade_chuva);
    	}
    	if (quantidade_chuva > 0) {

		    int quantidade_pocas <- 0;
		
		    if (quantidade_chuva <= 10) {
		        quantidade_pocas <- 1;
		    }
		    else if (quantidade_chuva <= 30) {
		        quantidade_pocas <- 2;
		    }
		    else if (quantidade_chuva <= 60) {
		        quantidade_pocas <- 3;
		    }
		    else {
		        quantidade_pocas <- 5;
		    }
		
		    create poca number: quantidade_pocas {
		        tamanho <- 1;
		    }
		}
	}	
	init
	{

		create ambiente from: subprefeituras_shapefile;
		create pessoa number: quantidade
		{
			location <- any_location_in(one_of(ambiente));
		}
		write "Tamanho do mundo: " + world.shape.width + " x " + world.shape.height;
		write "Pessoas: " + length(pessoa);
		write "Exemplo de posição: " + first(pessoa).location;

	}
		
}