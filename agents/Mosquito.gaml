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
    string sexo <- rnd(0, 1) = 0 ? "Macho" : "Femea";
    float velocidade <- 100.0;

    // =========================
    // Localização
    // =========================

    point poca_natal;

    float distancia_maxima <- 1690.0;


    float alcance <- 1800.0;

    // =========================
    // Probabilidades
    // =========================

    float prob_morte <- 0.15;

    float prob_migracao <- 0.0015;

    float prob_picada <- 0.5;
	//0.25
    float prob_mutacao <- 0.0;
    
    bool infectado <- false;


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

    // 1. Tentativa de picada e transmissão.
    if (rnd(0.0, 1.0) >= prob_picada) 
    {return;}

	list<pessoa> pessoas <- pessoa where (
	    each distance_to self <= 1800
	);
	
	if (!empty(pessoas)) {
	
	    pessoa alvo <- one_of(pessoas);
	
	    // Mosquito infectado transmite para pessoa suscetível.
	    if (alvo.estadoAtual = 0 and infectado) {
	        ask alvo {
	            do MudarEstado;
	        }
	    }
	
	    // Mosquito não infectado pode adquirir a infecção.
	    else if ((alvo.estadoAtual = 1 or alvo.estadoAtual = 2)
	        and !infectado) {
	        do MudarEstado;
	    }
	}
	
	
	list<poca> pocas <- poca where (
		each distance_to self <= 50000
	);
	// 2. Reprodução
	
	if (!empty(pocas)) {
	
	    poca pocaAlvo <- one_of(pocas);
	
	    if (length(pocaAlvo.ovos) < pocaAlvo.tamanho * 20) {
	
	        create ovo number: 100
	            returns: novosOvos {
	
	            poca_natal_ovo <- pocaAlvo;
	        }
	
	        add novosOvos all: true to: pocaAlvo.ovos;
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
	
	reflex andar 
	{

	    if (location distance_to poca_natal > distancia_maxima) {
	
	        do goto  target: poca_natal speed: velocidade;
	
	    } 
	    else 
	    {
	        do wander speed: velocidade;
	    }
		
		if(rnd(0.000, 1.000) < prob_migracao)
		{

			point a <- any_location_in(one_of(ambiente).shape);
			bool i <- infectado;
			
			
			create mosquito number: 1
			{
		        location <- a;
                poca_natal <- a;	
                infectado <- i;
    			cor <- infectado ? #red : #black;
                
    		}
			do die;	
		}
	}		

}

	

   