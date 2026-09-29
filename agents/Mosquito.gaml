/**
* Name: Mosquito
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model Mosquito

import "Pessoa.gaml"
import "Poca.gaml"

species mosquito skills: [moving]
{
	// =========================
    // Características básicas
    // =========================

    int idade <- rnd(1,33);
	int espectativaDeVida <- 33;
    string sexo <- rnd(0, 1) = 0 ? "Macho" : "Femea";
    bool infectado <- false;

    // =========================
    // Localização
    // =========================

    point poca_natal;

    float distancia_maxima <- 10.0;
    //690.0;

    float alcance <- 18.0;

    // =========================
    // Probabilidades
    // =========================

    float prob_morte <- 0.15;

    float prob_migracao <- 0.0051;

    float prob_picada <- 0.25;

    float prob_mutacao <- 0.0;


    // =========================
    // Epidemiologia
    // =========================

    float r0 <- 0.0;
	
	rgb cor <- #black;
	
	aspect default { draw circle(200) color: cor; }

	


	
	action MudarEstado
	{
		infectado <- !infectado;
		
		if(infectado)
		{
			cor <-	#orange;
		}
		else
		{
			cor <-	#black;
		}
	}
	
	
	action Picar {

	    if (rnd(0.0, 1.0) < prob_picada) {
	
	        list<pessoa> pessoas <- pessoa where
	            (each distance_to self <= 18);
	
	        if (!empty(pessoas)) {
	
	            pessoa alvo <- one_of(pessoas);
	
	            if ((alvo.estadoAtual = 1 or alvo.estadoAtual = 2)
	                and !infectado) {
	
	                do MudarEstado;
	            }
	
	            if (alvo.estadoAtual = 0 and infectado) {
	                ask alvo {
				        do MudarEstado;
				    }
	            }
	            
	            list<poca> pocas <- poca where
	            (each distance_to self <= 18);
	            
	            if (!empty(pocas)) {
	
	           		poca pocaAlvo <- one_of(pocas);

					if (length(pocaAlvo.ovos) < pocaAlvo.tamanho * 20) {

					    create ovo number: 100 {
					
					        poca_natal_ovo <- pocaAlvo;
					
					        add self to: pocaAlvo.ovos;
					    }
					}
	            }
	        }
	    }
	}

	
	
	action Envelhecer
	{
	    idade <- idade + 1;
	
		if (rnd(0.0, 1.0) < prob_morte or idade = 33) 
		{
	        do die;
	    }
    }
	
	reflex andar {

    if (location distance_to poca_natal > distancia_maxima) {

        do goto target: poca_natal;

    } else {

        do wander;

    }

}

}

	

   