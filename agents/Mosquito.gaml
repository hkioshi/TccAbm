/**
* Name: Mosquito
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model Mosquito

import "Paciente.gaml"
import "Poca.gaml"

species mosquito skills: [moving]
{
	// =========================
    // Características básicas
    // =========================

    int idade <- rnd(1,33);
	int espectativaDeVida <- 33;
    

    string sexo <- rnd(0, 1) = 0 ? "Macho" : "Femea";

    bool infectado <- rnd(0.0,1.0) < 5 ? true : false;


    // =========================
    // Ciclo de vida
    // =========================

    string fase <- "ovo";


    int tempo_ovo <- 0;

    int tempo_larva <- 0;

    int tempo_pupa <- 0;




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
	
	aspect default {
		draw square(0.5) color: cor;
	}
	
	
	action Picar {

    if (rnd(0.0, 1.0) < prob_picada) {

        list<pessoa> pessoas <- pessoa where
            (each distance_to self <= 18);

        if (!empty(pessoas)) {

            pessoa alvo <- one_of(pessoas);

            if ((alvo.estadoAtual = 1 or alvo.estadoAtual = 2)
                and !infectado) {

                infectado <- true;
                cor <- #purple;
            }

            if (alvo.estadoAtual = 0 and infectado) {

                alvo.estadoAtual <- alvo.estadoAtual + 1;
                cor <- #orange;
            }
        }
    }
    
    
    
    
    
}

	action Botar_Ovos
	{
		list<poca> pocas <- poca where
            (each distance_to self <= 18);

        if (!empty(pocas)) {

            poca alvo <- one_of(pocas);
			
            
        }
	}
	
	
	action Envelhecer {
	
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

	

   