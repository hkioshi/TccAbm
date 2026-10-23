model Main

import "agents/Mosquito.gaml"
import "agents/Pessoa.gaml"
import "agents/Ambiente.gaml"
import "agents/Poca.gaml"
import "globals/globals.gaml"
experiment MeuExperimento type: gui {
	parameter "Velocidade do tempo"
	    var: velocidade_tempo
	    min: 1
	    max: 5
	    step: 1;
	
	parameter "Percentual de vacinados (%)"
	    var: porcentagem_de_vacinados
	    min: 0.0
	    max: 100.0
	    step: 1.0;
	
	parameter "Seed"
	    var: seed
	    min: 1.0
	    max: 2147483647.0
	    step: 1;
	    
    parameter "Eficácia da vacina (%)"
    var: eficacia min: 0 max: 100 step: 1;
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

	output {
		display mundo type: 2d {
			species ambiente aspect: default transparency: 0.5;
			species pessoa;
			species mosquito;
			species poca;
			event #mouse_down action: clicar;
		}

		// ─── TEMPO ───
		monitor "⏱ Ciclo" value: cycle;
		monitor "📅 Dia" value: dia;
		monitor "🗓 Mês" value: mes;
		monitor "🕒 Hora" value: hora;

		// ─── POPULAÇÃO HUMANA ───
		monitor "👥 Humanos" value: length(pessoa);
		monitor "🦠 Humanos suscetíveis" value: length(pessoa where (each.estado = 0));
		monitor "🟡 Humanos expostos" value: length(pessoa where (each.estado = 1));
		monitor "🔴 Humanos infectados" value: length(pessoa where (each.estado = 2));
		monitor "🟢 Humanos recuperados" value: length(pessoa where (each.estado = 3));

		// ─── MORTALIDADE ───
		monitor "⚰ Mortes por dengue" value: mortos_por_dengue;

		// ─── POPULAÇÃO DE MOSQUITOS ───
		monitor "🦟 Mosquitos" value: length(mosquito);
		monitor "Mosquitos suscetíveis" value: length(mosquito where (each.estado = 0));
		monitor "Mosquitos expostos" value: length(mosquito where (each.estado = 1));
		monitor "Mosquitos infectados" value: length(mosquito where (each.estado = 2));
	}

}