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
import "variaveis.gaml"





global {
	// Dados climáticos
	int tempo_hora <- 5;
	int tempo_dia <- 24*5;
	float temperatura;
	float chuva <- 0.0;
	int velocidade_tempo <- 1;

	// Tempo
	int mes <- 1;
	int dia <- 0;
	int hora <- 0;

	file arquivo_resultados <- file("resultados.csv");
	
	action Relatorio
{
    save [
        dia,
        chuva,
        temperatura,
        // Humanos
        length(pessoa),
        length(pessoa where (each.estado = 0)),
        length(pessoa where (each.estado = 1)),
        length(pessoa where (each.estado = 2)),
        length(pessoa where (each.estado = 3)),

        // Mosquitos
        length(mosquito),
        length(mosquito where (each.estado = 0)),
        length(mosquito where (each.estado = 1)),
        length(mosquito where (each.estado = 2)),

        // Mortalidade
        mortos_por_dengue,
        mortes_menor_1_ano,
        mortes_1_a_19_anos,
        mortes_20_a_39_anos,
        mortes_40_a_59_anos,
        mortes_60_a_79_anos,
        mortes_80_anos_ou_mais
	    ]
	    to: "resultados.csv"
	    format: "csv"
	    rewrite: false
	    header: false;
	}
			
	// Dados geográficos
	file subprefeituras_shapefile <- file("../Gis/subprefeitura_v2.shp");
	geometry shape <- envelope(subprefeituras_shapefile); // Nao mexer | caso de se trocar o nome nao sei o que acontece mas faz o mapa sumir
	// Dados epidemiológicos
	int quantidade_mosquito <- 100;
	int quantidade_pessoas <- 1191; // escala de 1:10000
	int mortos_por_dengue <- 0;
	int mortes_menor_1_ano <- 0;       // Menores de 1 ano
	int mortes_1_a_19_anos <- 0;       // 1 a 19 anos
	int mortes_20_a_39_anos <- 0;      // 20 a 39 anos
	int mortes_40_a_59_anos <- 0;      // 40 a 59 anos
	int mortes_60_a_79_anos <- 0;      // 60 a 79 anos
	int mortes_80_anos_ou_mais <- 0;   // 80 anos ou mais
	
	float porcentagem_de_vacinados;
	int eficacia;

	//| Região | População  | Participação |
	//| ------ | ---------- | ------------ |
	//| Centro | 563.877    | 5,0%         |
	//| Norte  | 1.229.117  | 10,9%        |
	//| Leste  | 4.011.035  | 35,6%        |
	//| Sul    | 5.239.732  | 46,6%        |
	//| Oeste  | 1.208.299  | 10,7%        |
	//| Total  | 11.252.060 | 100%         |
	//https://gestaourbana.prefeitura.sp.gov.br/wp-content/uploads/2024/05/IU_64_censo-2022-1.pdf	
	
	init {
		save [
	        "dia",
        	"chuva",
        	"temperatura",
	        "humanos_total",
	        "humanos_suscetiveis",
	        "humanos_expostos",
	        "humanos_infectados",
	        "humanos_recuperados",
	
	        "mosquitos_total",
	        "mosquitos_suscetiveis",
	        "mosquitos_expostos",
	        "mosquitos_infectados",
	
	        "mortos_por_dengue",
	        "mortes_menor_1_ano",
	        "mortes_1_a_19_anos",
	        "mortes_20_a_39_anos",
	        "mortes_40_a_59_anos",
	        "mortes_60_a_79_anos",
	        "mortes_80_anos_ou_mais"
	    ]
	    to: "resultados.csv"
	    format: "csv"
	    rewrite: true
	    header: false;
	    
		seed <- 12345.0;
		write "Seed utilizada: " + seed;
		create ambiente from: subprefeituras_shapefile with: [nm_regiao_::read("nm_regiao_")];

	
		
		create mosquito number: 100 {
			location <- any_location_in(one_of(ambiente));
			
			poca_natal <- location;
			estado <- rnd(0,3);
			switch estado
			{
				match 0 {cor <- rgb(204, 121, 167);}
				match 1 {cor <- rgb(240, 228, 66);}
				match 2 {cor <- rgb(51, 34, 136);}
			}
		}

		int qtd_centro <- int(quantidade_pessoas * 0.0370);
		int qtd_norte <- int(quantidade_pessoas * 0.1929);
		int qtd_leste <- int(quantidade_pessoas * 0.3485);
		int qtd_sul <- int(quantidade_pessoas * 0.3262);
		int qtd_oeste <- quantidade_pessoas - qtd_centro - qtd_norte - qtd_leste - qtd_sul;
		
		create pessoa number: qtd_centro {
		    location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Centro")).shape);
		    vacinado <- rnd(100) < porcentagem_de_vacinados;
		}
		
		create pessoa number: qtd_norte {
		    location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Norte")).shape);
		    vacinado <- rnd(100) < porcentagem_de_vacinados;
		}
		
		create pessoa number: qtd_leste {
		    location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Leste")).shape);
		    vacinado <- rnd(100) < porcentagem_de_vacinados;
		}
		
		create pessoa number: qtd_sul {
		    location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Sul")).shape);
		    vacinado <- rnd(100) < porcentagem_de_vacinados;
		}
		
		create pessoa number: qtd_oeste {
		    location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Oeste")).shape);
		    vacinado <- rnd(100) < porcentagem_de_vacinados;
		}

		write "Pessoas: " + length(pessoa);
		write "Subprefeituras: " + length(ambiente);
	}

	reflex atualizar_hora when: every(tempo_hora #cycles) {
		hora <- (hora + 1) mod 24;
		ask (mosquito where (each.sexo = "Femea")) {
			do Picar;
		}
		
	}

	reflex evento when: every(tempo_dia * velocidade_tempo #cycles) {
			if (dia > 30) {
			dia <- 1;
			if (mes < 12) {
				mes <- mes + 1;
			} else {
				mes <- 1;
			}

		}
	
	
		write dia;
		do Relatorio;
		
		ask pessoa {
			do Envelhecer;
			do Nascer;
		}

		ask mosquito {
			do Envelhecer;
		}

		// Fonte dos dados meteorológicos: INMET - Dados Históricos
		// https://portal.inmet.gov.br/dadoshistoricos
		// Foram utilizados os dados diários de 2023, 2024 e 2025.
		// Para cada mês, foram reunidos os registros dos três anos.
		// A probabilidade de chuva foi calculada dividindo o número de dias
		// com precipitação maior que 0 mm pelo total de dias com dados válidos
		// registrados naquele mês, multiplicando o resultado por 100.
		// Assim, a probabilidade representa a frequência histórica de dias chuvosos
		// em cada mês, e não a quantidade de chuva acumulada.
		// Os valores foram utilizados como referência para a simulação da chuva.
		
		switch mes {
			match 1 {
				if (rnd(100.0) < 73.1) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 2 {
				if (rnd(100.0) < 62.4) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 3 {
				if (rnd(100.0) < 49.5) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 4 {
				if (rnd(100.0) < 42.2) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 5 {
				if (rnd(100.0) < 21.5) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 6 {
				if (rnd(100.0) < 27.8) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 7 {
				if (rnd(100.0) < 18.3) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 8 {
				if (rnd(100.0) < 16.1) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 9 {
				if (rnd(100.0) < 15.6) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 10 {
				if (rnd(100.0) < 48.4) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 11 {
				if (rnd(100.0) < 41.6) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

			match 12 {
				if (rnd(100.0) < 53.8) {
					chuva <- rnd(0.0, 30.0);
				} else {
					chuva <- 0.0;
				}

			}

		}

	

		write chuva;
				ask imaturo {
			do Envelhecer(chuva);
		}
		
		
		// Dados meteorológicos: estação automática São Paulo - Mirante (INMET),
		// código da estação A701, localizada na cidade de São Paulo (SP).
		//
		// Período utilizado: 2023 a 2025.
		// Os dados diários foram organizados em um CSV contendo a data,
		// a temperatura mínima, a temperatura máxima e a precipitação diária.
		//
		// Método de cálculo:
		// 1. Os registros foram agrupados por mês do calendário.
		// 2. Para cada mês, foi calculada a média das temperaturas mínimas diárias.
		// 3. Também foi calculada a média das temperaturas máximas diárias.
		// 4. Os valores médios dos três anos foram usados para definir
		//    uma faixa de temperatura representativa de cada mês.
		//
		// Exemplo: para janeiro, a média das mínimas foi de 19,6 °C
		// e a média das máximas foi de 28,1 °C.
		//
		// Durante a simulação, o mês atual seleciona a faixa correspondente.
		// A temperatura diária é sorteada dentro dessa faixa com rnd().
		//
		// IMPORTANTE: essa abordagem representa uma variação diária aleatória
		// dentro da faixa média mensal, não a temperatura real observada em cada dia.
		// Os valores representam médias climatológicas do período analisado,
		// não normais climatológicas oficiais de 30 anos do INMET.
				
		float temperatura_min;
		float temperatura_max;
		
		switch mes {
		    match 1 {
		        temperatura_min <- 19.6;
		        temperatura_max <- 28.1;
		    }
		    match 2 {
		        temperatura_min <- 20.3;
		        temperatura_max <- 29.5;
		    }
		    match 3 {
		        temperatura_min <- 19.9;
		        temperatura_max <- 29.1;
		    }
		    match 4 {
		        temperatura_min <- 18.1;
		        temperatura_max <- 26.3;
		    }
		    match 5 {
		        temperatura_min <- 16.4;
		        temperatura_max <- 25.1;
		    }
		    match 6 {
		        temperatura_min <- 14.6;
		        temperatura_max <- 23.5;
		    }
		    match 7 {
		        temperatura_min <- 13.4;
		        temperatura_max <- 22.5;
		    }
		    match 8 {
		        temperatura_min <- 14.3;
		        temperatura_max <- 24.9;
		    }
		    match 9 {
		        temperatura_min <- 17.0;
		        temperatura_max <- 28.2;
		    }
		    match 10 {
		        temperatura_min <- 17.1;
		        temperatura_max <- 26.0;
		    }
		    match 11 {
		        temperatura_min <- 18.2;
		        temperatura_max <- 27.1;
		    }
		    match 12 {
		        temperatura_min <- 19.9;
		        temperatura_max <- 29.2;
		    }
		}
		
		temperatura <- rnd(temperatura_min, temperatura_max);
		ask poca {
			do Envelhecer(chuva);
		}
		
		dia <- dia +1;

		if (chuva > 0) {
			int quantidade_pocas <- 0;
			if (chuva <= 10) {
				quantidade_pocas <- 10;
			} else if (chuva <= 30) {
				quantidade_pocas <- 20;
			} else if (chuva <= 60) {
				quantidade_pocas <- 30;
			} else {
				quantidade_pocas <- 50;
			}

			create poca number: quantidade_pocas {
				tamanho <- 1;
				location <- any_location_in(one_of(ambiente).shape);
			} } } }