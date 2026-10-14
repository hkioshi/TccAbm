/**
 * Name: Pessoa
 * Author: henrique
 */
model Pessoa

import "../globals/globals.gaml"
species pessoa skills: [moving] {

// Identificação e saúde
	int idade <- rnd(10 * 365, 80 * 365);
	int espectativaDeVida <- 77 * 365;
	int idade_avancada <- 2;
	
	int estado <- 0;
	int dias_Infectado <- 0;
	float mortalidade_menor_1_ano <- 0.106; //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float mortalidade_1_a_19_anos <- 0.018;  //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float mortalidade_20_a_39_anos <- 0.033; //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float mortalidade_40_a_59_anos <- 0.068; //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float mortalidade_60_a_79_anos <- 0.271; //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float mortalidade_80_anos_ou_mais <- 1.52;	 //https://ojs.thesiseditora.com.br/index.php/jsihs/article/download/407/363/1494
	float prob_transmissao <- 60.0;//https://aamas.csc.liv.ac.uk/AAMAS/aamas2017/proceedings/pdfs/p426.pdf
	int periodo_incubacao <- rnd(5, 7); //https://pmc.ncbi.nlm.nih.gov/articles/PMC3670336/ 
	int periodo_viral <- rnd(4, 5); //https://pmc.ncbi.nlm.nih.gov/articles/PMC3670336/
	int periodo_recuperacao <- 120; //https://www.nature.com/articles/s41467-019-09193-y
	float taxa_de_mortalidade_dia <-  0.0019; //https://prefeitura.sp.gov.br/documents/d/licenciamento/10_taxas_de_mortalidade_geral_e_infantil_1980_2023_pdf
	float taxa_de_mortalidade_dengue;
	bool vacinado <- false;
	rgb cor <- #green;

	// Localização e deslocamento

	point destino;
	bool em_movimento <- false;
	float velocidade <- 10.0;
	float velocidade_parado <- 10.0;
	float velocidade_andando <- 300.0;

	aspect default {
		draw circle(150) color: cor;
	}

	// --------------------------------------------------
	// Movimento
	// --------------------------------------------------
	reflex andar {
		if ((hora >= 5 and hora < 8) or (hora >= 16 and hora < 19)) {

		// Sorteia um destino quando necessário
			if (destino = nil) {
				destino <- sortear_destino(location);
				velocidade <- velocidade_andando;
			}

			// Caminha até o destino
			if (destino != nil) {
				do goto target: destino speed: velocidade;
				if (location distance_to destino < velocidade) {
					destino <- nil;
					em_movimento <- false;
					velocidade <- velocidade_parado;
				}

			}

		} else {

		// Movimento local fora dos horários de deslocamento
			destino <- nil;
			velocidade <- velocidade_parado;
			do wander speed: velocidade amplitude: 360.0;
		}

		// Retorna ao mapa caso saia da área das subprefeituras
		if (empty(ambiente overlapping location)) {
			location <- any_location_in(one_of(ambiente).shape);
			destino <- nil;
		}

	}

	// --------------------------------------------------
	// Regiões e destinos
	// --------------------------------------------------
	string obter_regiao (point pos) {
		loop regiao over: ambiente {
			if (regiao.shape overlaps pos) {
				return regiao.nm_regiao_;
			}

		}

		return "";
	}

	point sortear_localizacao (string nome_regiao) {
		list<ambiente> regioes <- ambiente where (each.nm_regiao_ = nome_regiao);
		if (empty(regioes)) {
			return nil;
		}

		ambiente subprefeitura <- one_of(regioes);
		return any_location_in(subprefeitura.shape);
	}

	point sortear_destino (point pos) {
		string origem <- obter_regiao(pos);
		if (origem = "") {
			return nil;
		}

		string regiao <- sortear_regiao_destino(origem);
		return sortear_localizacao(regiao);
	}

	string sortear_regiao_destino (string origem) {
		float sorteio <- rnd(0.0, 100.0);
		string regiao <- origem;

		// Manhã: 5h às 9h
		if (hora >= 5 and hora < 9) {
			switch origem {
				match "Centro" {
					switch sorteio {
						match_between [0, 58.8] {
							regiao <- "Centro";
							break;
						}

						match_between [58.8, 62.7] {
							regiao <- "Norte";
							break;
						}

						match_between [62.7, 75.5] {
							regiao <- "Sul";
							break;
						}

						match_between [75.5, 87.2] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Norte" {
					switch sorteio {
						match_between [0, 7.3] {
							regiao <- "Centro";
							break;
						}

						match_between [7.3, 78.4] {
							regiao <- "Norte";
							break;
						}

						match_between [78.4, 82.8] {
							regiao <- "Sul";
							break;
						}

						match_between [82.8, 87.5] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Sul" {
					switch sorteio {
						match_between [0, 6.7] {
							regiao <- "Centro";
							break;
						}

						match_between [6.7, 7.7] {
							regiao <- "Norte";
							break;
						}

						match_between [7.7, 83.6] {
							regiao <- "Sul";
							break;
						}

						match_between [83.6, 86.8] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Leste" {
					switch sorteio {
						match_between [0, 7.3] {
							regiao <- "Centro";
							break;
						}

						match_between [7.3, 9.0] {
							regiao <- "Norte";
							break;
						}

						match_between [9.0, 14.3] {
							regiao <- "Sul";
							break;
						}

						match_between [14.3, 93.6] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Oeste" {
					switch sorteio {
						match_between [0, 10.1] {
							regiao <- "Centro";
							break;
						}

						match_between [10.1, 15.1] {
							regiao <- "Norte";
							break;
						}

						match_between [15.1, 27.8] {
							regiao <- "Sul";
							break;
						}

						match_between [27.8, 29.9] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

			}

			// Tarde: 16h às 20h
		} else if (hora >= 16 and hora < 20) {
			switch origem {
				match "Centro" {
					switch sorteio {
						match_between [0, 26.4] {
							regiao <- "Centro";
							break;
						}

						match_between [26.4, 41.7] {
							regiao <- "Norte";
							break;
						}

						match_between [41.7, 62.3] {
							regiao <- "Sul";
							break;
						}

						match_between [62.3, 89.1] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Norte" {
					switch sorteio {
						match_between [0, 2.0] {
							regiao <- "Centro";
							break;
						}

						match_between [2.0, 90.1] {
							regiao <- "Norte";
							break;
						}

						match_between [90.1, 92.0] {
							regiao <- "Sul";
							break;
						}

						match_between [92.0, 96.4] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Sul" {
					switch sorteio {
						match_between [0, 2.6] {
							regiao <- "Centro";
							break;
						}

						match_between [2.6, 4.8] {
							regiao <- "Norte";
							break;
						}

						match_between [4.8, 89.5] {
							regiao <- "Sul";
							break;
						}

						match_between [89.5, 96.1] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Leste" {
					switch sorteio {
						match_between [0, 1.7] {
							regiao <- "Centro";
							break;
						}

						match_between [1.7, 4.1] {
							regiao <- "Norte";
							break;
						}

						match_between [4.1, 7.0] {
							regiao <- "Sul";
							break;
						}

						match_between [7.0, 86.3] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

				match "Oeste" {
					switch sorteio {
						match_between [0, 5.5] {
							regiao <- "Centro";
							break;
						}

						match_between [5.5, 21.5] {
							regiao <- "Norte";
							break;
						}

						match_between [21.5, 48.3] {
							regiao <- "Sul";
							break;
						}

						match_between [48.3, 60.8] {
							regiao <- "Leste";
							break;
						}

						default {
							regiao <- "Oeste";
						}

					}

				}

			}

		}

		return regiao;
	}

	// --------------------------------------------------
	// Estado de saúde
	// --------------------------------------------------
	action MudarEstado {
		estado <- estado + 1;
		if (estado > 3) {
			estado <- 0;
			dias_Infectado <- 0;
		}

		switch estado {
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


    action Envelhecer {
        idade <- idade + 1;

        if (estado > 0) {
            dias_Infectado <- dias_Infectado + 1;
        }

        if (estado = 1 and dias_Infectado >= periodo_incubacao) {
            do MudarEstado;

            if (rnd(0.0, 100.0) < taxa_de_mortalidade_dengue) {

			    if (idade < 365) {
			        mortes_menor_1_ano <- mortes_menor_1_ano + 1;
			    } else if (idade < 20 * 365) {
			        mortes_1_a_19_anos <- mortes_1_a_19_anos + 1;
			    } else if (idade < 40 * 365) {
			        mortes_20_a_39_anos <- mortes_20_a_39_anos + 1;
			    } else if (idade < 60 * 365) {
			        mortes_40_a_59_anos <- mortes_40_a_59_anos + 1;
			    } else if (idade < 80 * 365) {
			        mortes_60_a_79_anos <- mortes_60_a_79_anos + 1;
			    } else {
			        mortes_80_anos_ou_mais <- mortes_80_anos_ou_mais + 1;
			    }
			
			    mortos_por_dengue <- mortos_por_dengue + 1;
			    do die;
			}
        }

        if (estado = 2 and dias_Infectado >= periodo_incubacao + periodo_viral) {
            do MudarEstado;
        }

        if (estado = 3 and dias_Infectado >= periodo_incubacao + periodo_viral + periodo_recuperacao) {
            do MudarEstado;
     
        }

        if (rnd(0.0000, 1.0000) < taxa_de_mortalidade_dia) {
            do die;
        }

        if (estado > 0) {
            dias_Infectado <- dias_Infectado + 1;
        }

        if (estado = 1 and dias_Infectado >= periodo_incubacao) {
            do MudarEstado;

            if (rnd(1, 10000) <= 2) {
                do die;
            }
        }

        if (estado = 2 and dias_Infectado >= periodo_incubacao + periodo_viral) {
            do MudarEstado;
        }

        if (estado = 3 and dias_Infectado >= periodo_incubacao + periodo_viral + periodo_recuperacao) {
            do MudarEstado;
        }

        if (idade > espectativaDeVida) {
            float PorcentagemExtra <- (idade - espectativaDeVida) / 365.0;

            if (rnd(1, 48300) = 1 + 484 * PorcentagemExtra) {
                do die;
                mortos_por_dengue <- mortos_por_dengue + 1;
            }
        }
    }

    // --------------------------------------------------
    // Nascimento
    // --------------------------------------------------
    action Nascer {
        if (rnd(1, 35714) = 1) {
            create pessoa number: 1 with: [
                idade::0,
                location::any_location_in(one_of(ambiente).shape)
            ];
        }
    }
}
