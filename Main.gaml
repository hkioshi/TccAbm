model Main

import "agents/Mosquito.gaml"
import "agents/Pessoa.gaml"
import "agents/Ambiente.gaml"
import "agents/Poca.gaml"
import "globals/globals.gaml"
experiment MeuExperimento type: gui {
	parameter "Quantidade inicial" var: velocidade_tempo min: 1 max: 5 step: 1;

	action clicar {
		point pos <- #user_location;
		int encontradas <- 0;
		loop regiao over: ambiente {
			if (regiao.shape overlaps pos) {
				encontradas <- encontradas + 1;
				write "Região: " + regiao.nm_regiao_;
			}
		}
		write "Total encontrado: " + encontradas;
	}

	action gerar_mosquito {
		point pos <- #user_location;
		write "asda";
		create mosquito number: 100 {
			poca_natal <- pos;
			location <- pos;
			estado <- rnd(0,3);
			switch estado
			{
				match 0 {cor <- rgb(204, 121, 167);}
				match 1 {cor <- rgb(240, 228, 66);}
				match 2 {cor <- rgb(51, 34, 136);}
			}
		}
	}

	output {
		display mundo type: 2d {
			species ambiente aspect: default transparency: 0.5;
			species pessoa;
			species mosquito;
			species poca;
			event #mouse_down action: gerar_mosquito;
		}

		monitor "Ciclo atual" value: cycle;
		monitor "Dia" value: dia;
		monitor "Mês" value: mes;
		monitor "Hora" value: hora;
		monitor "Pessoas" value: length(pessoa);
		monitor "Mosquitos" value: length(mosquito);
		monitor "Ovos" value: length(ovo);
		monitor "Poças" value: length(poca);
	}

}