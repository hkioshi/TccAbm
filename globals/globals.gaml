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

global {
	// Dados climáticos
	int temperatura;
	float chuva <- 0.0;
	int velocidade_tempo <- 1;

	// Tempo
	int mes <- 1;
	int dia <- 0;
	int hora <- 0;

	// Dados geográficos
	file subprefeituras_shapefile <- file("../Gis/subprefeitura_v2.shp");
	geometry shape <- envelope(subprefeituras_shapefile); // Nao mexer | caso de se trocar o nome nao sei o que acontece mas faz o mapa sumir
	// Dados epidemiológicos
	
	int quantidade_pessoas <- 1191; // escala de 1:10000
	int mortos_por_dengue <- 0;
	int mortes_menor_1_ano <- 0;       // Menores de 1 ano
	int mortes_1_a_19_anos <- 0;       // 1 a 19 anos
	int mortes_20_a_39_anos <- 0;      // 20 a 39 anos
	int mortes_40_a_59_anos <- 0;      // 40 a 59 anos
	int mortes_60_a_79_anos <- 0;      // 60 a 79 anos
	int mortes_80_anos_ou_mais <- 0;   // 80 anos ou mais
	

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
		seed <- 12345.0;
		write "Seed utilizada: " + seed;
		create ambiente from: subprefeituras_shapefile with: [nm_regiao_::read("nm_regiao_")];

		create pessoa number: int(quantidade_pessoas * 0.3560) {
			location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Leste")).shape);
		}

				create pessoa number: int(quantidade_pessoas * 0.4660) {
			location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Sul")).shape);
		}

				create pessoa number: int(quantidade_pessoas * 0.1090) {
			location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Norte")).shape);
		}

		create pessoa number: int(quantidade_pessoas * 0.1070) {
			location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Oeste")).shape);
		}

		create pessoa number: int(quantidade_pessoas * 0.0500) {
			location <- any_location_in(one_of(ambiente where (each.nm_regiao_ = "Centro")).shape);
		}

		write "Pessoas: " + length(pessoa);
		write "Subprefeituras: " + length(ambiente);
	}

	reflex atualizar_hora when: every(10 #cycles) {
		hora <- (hora + 1) mod 24;
	}

	reflex evento when: every(240 * velocidade_tempo #cycles) {
		dia <- dia + 1;
		if (dia > 30) {
			dia <- 1;
			if (mes < 12) {
				mes <- mes + 1;
			} else {
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
		//fonte = https://portal.inmet.gov.br/dadoshistoricos 
		//media dos meses de 2023,24 e 25
		//somados todos os dias e tiradas as medias
		
		float quantidade_chuva;
		switch mes {
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

		write quantidade_chuva;
		dia <- dia + 1;
		temperatura <- rnd(15, 35);
		ask poca {
			do Envelhecer(quantidade_chuva);
		}

		if (quantidade_chuva > 0) {
			int quantidade_pocas <- 0;
			if (quantidade_chuva <= 10) {
				quantidade_pocas <- 10;
			} else if (quantidade_chuva <= 30) {
				quantidade_pocas <- 20;
			} else if (quantidade_chuva <= 60) {
				quantidade_pocas <- 30;
			} else {
				quantidade_pocas <- 50;
			}

			create poca number: quantidade_pocas {
				tamanho <- 1;
				location <- any_location_in(one_of(ambiente).shape);
			} } } }