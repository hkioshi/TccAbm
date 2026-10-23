/**
* Name: Mosquito
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/
model Mosquito
import "../globals/globals.gaml"

import "Pessoa.gaml"
import "Poca.gaml"
species mosquito skills: [moving] {
	// =========================
	// Características básicas
	// =========================
	int idade <- rnd(1, 33);
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
	float prob_picada <- 0.25;
	float prob_mutacao <- 0.0;
	float prob_transmissao <- 27.50;

	// =========================
	// Epidemiologia
	// =========================
	int estado <- 0;
	// 1 - Suscetíveis
	// 2 - Expostos
	// 3 - Infectados
	int dias_infectado <- 0;
	int dias_de_incubacao;
	float r0 <- 0.0;

	// Rosa: rgb(204, 121, 167) — Suscetível
	// Amarelo: rgb(240, 228, 66) — Exposto
	// Azul-arroxeado: rgb(51, 34, 136) — Infectado
	rgb cor <- rgb(204, 121, 167);

	aspect default {
		draw square(150) color: cor;
	}

	action MudarEstado {
		estado <- (estado + 1) mod 3;
		switch estado {
			match 0 {
				cor <- rgb(204, 121, 167);
			}

			match 1 {
				cor <- rgb(240, 228, 66);
			}

			match 2 {
				cor <- rgb(51, 34, 136);
			}

		}

	}

	action Picar {

	// 1. Tentativa de picada e transmissão.
		if (rnd(0.0, 1.0) >= prob_picada) {
			return;
		}

		list<pessoa> pessoas <- pessoa where (each distance_to self <= 1800);
		if (!empty(pessoas)) {
			pessoa alvo <- one_of(pessoas);

			if (alvo.estado = 0 and estado = 2) {
				ask alvo {
				    float prob_efetiva <- prob_transmissao;
				
				    if (vacinado) {
				        prob_efetiva <- prob_transmissao * (1 - eficacia / 100.0);
				    }
				
				    if (rnd(1, 100) <= prob_efetiva) {
				        do MudarEstado;
				    }
				}

			} else if ((alvo.estado = 1 or alvo.estado = 2) and estado = 0) {
				if (rnd(1.0, 100.0) < prob_transmissao) {
					do MudarEstado;
					dias_de_incubacao <- rnd(3, 10);
				}

			}
			list<poca> pocas <- poca where (each distance_to self <= 50000);
			// 2. Reprodução
			if (!empty(pocas)) {
				poca pocaAlvo <- one_of(pocas);
				if (length(pocaAlvo.imaturos) < pocaAlvo.tamanho * 20) {
					create imaturo number: 100 returns: novosImaturos {
						poca_natal <- pocaAlvo;
					}
	
					add novosImaturos all: true to: pocaAlvo.imaturos;
				}
	
			}
		}
	}

	action Envelhecer {
		idade <- idade + 1;
		if (estado > 0) {
			dias_infectado <- dias_infectado + 1;
			if (dias_infectado = dias_de_incubacao) {
				do MudarEstado;
			}

		}

		if (rnd(0.0, 1.0) < prob_morte or idade = 33) {
			do die;
		}

	}

	reflex andar {
		if (location distance_to poca_natal > distancia_maxima) {
			do goto target: poca_natal speed: velocidade;
		} else {
			do wander speed: velocidade;
		}

//		if (rnd(0.000, 1.000) < prob_migracao) {
//			point a <- any_location_in(one_of(ambiente).shape);
//			int i <- estado;
//			create mosquito number: 1 {
//				location <- a;
//				poca_natal <- a;
//				estado <- i;
//				switch estado {
//					match 0 {
//						cor <- rgb(204, 121, 167);
//					}
//
//					match 1 {
//						cor <- rgb(240, 228, 66);
//					}
//
//					match 2 {
//						cor <- rgb(51, 34, 136);
//					}
//
//				}
//
//			}
//
//			do die;
//		}

	}

}

	

   