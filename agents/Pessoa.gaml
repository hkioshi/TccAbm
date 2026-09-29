/**
* Name: Paciente
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model Pessoa

import "../globals/globals.gaml"

species pessoa skills: [moving]
{
	int idade <- rnd(10 * 365, 80*365);
	int espectativaDeVida <- 77 * 365;
	int altura <- rnd(10, 50);
	list<string> estados <- ["Saudavel", "Exposto", "infectado", "Recuperado"];
	int estadoAtual <- 0;
	int dias_Infectado <- 0;
	float prob_transmissao <- 0.275;

    int periodo_incubacao <- rnd(5, 7);
    int periodo_viral <- rnd(4, 5);
    int periodo_recuperacao <- 120;

    // Localização
    point residencia;
    point trabalho;

    // Trabalho
    int hora_entrada <- 8;
    int hora_saida <- rnd(16, 24);

    // Deslocamento
    float velocidade <- rnd(50.0, 80.0);

    // Vacinação
    bool vacinado <- false;
	
	rgb cor <- #green;
	
	
	
    // Mosquito.gaml
	// Pessoa.gaml
aspect default { draw circle(250) color: #blue; }


	reflex andar {

        do wander;

    }
    
    
    action MudarEstado
    {
    	estadoAtual <- estadoAtual+1;
    	if(estadoAtual > 3)
    	{
    		estadoAtual <- 0;
    		dias_Infectado <- 0;
    	}
    	
    	switch estadoAtual {
		    match 0 {
		        cor <- #green;
		        dias_Infectado <- 0;
		    }
		
		    match 1 {
				cor <- #red;

		    }
		    match 2 {
		    	cor <- #purple;
		    }
		    
		    match 3 {
		        cor <- #cyan;
		    }
		} 
    	
    	
    }
    
    action Envelhecer
    {
    	if(estadoAtual > 0)
    	{
			dias_Infectado <- dias_Infectado + 1;
    	}
	
    	if(estadoAtual = 1 and dias_Infectado >= periodo_incubacao)
    	{
			do MudarEstado;
			if(rnd(1,10000) <= 2)
			{
				do die;
			}
			
    	}	
    	
    	if(estadoAtual = 2 and dias_Infectado >= periodo_incubacao + periodo_viral)
    	{
			do MudarEstado;
			
    	}
    	
    	if(estadoAtual = 3 and dias_Infectado >= periodo_incubacao + periodo_viral + periodo_recuperacao)
    	{
			do MudarEstado;
			cor <- #green;
			dias_Infectado <- 0;
			
		}
		
		
    	
    	
    	
    	dias_Infectado <- dias_Infectado + 1;
    	if(idade > espectativaDeVida)
    	{
    		float PorcentagemExtra <- (idade - espectativaDeVida) / 365.0;
    		if (rnd(1,48300) = 1+ 484 * PorcentagemExtra)
    		{
    			do die;
    			mortos_por_dengue <- mortos_por_dengue + 1;
    			// 1 em 48300 = 0,00207% media mundial morte/dia
    		}
    	}
    	if (rnd(1,48300) = 1)
    		{
    			do die;
    		}
    		
    	idade <- idade + 1;
    	
    }
    
    action Nascer
    {
    	if (rnd(1,35714) = 1)
		{
			create pessoa number: 1 with: [
			    idade::0
			];    			
			// 1 em 48300 = 0,00207% media mundial morte/dia
		}	
    }
}

