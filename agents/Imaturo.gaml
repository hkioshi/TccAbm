/**
* Name: Ovo
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/
model Imaturo

import "Mosquito.gaml"
import "Poca.gaml"
species imaturo {

// 0 = ovo, 1 = larva, 2 = pupa
	int estagio <- 0;
	int idade <- 0;
	int duracao_estagio <- 0;
	poca poca_natal;

	action DefinirDuracao {

	// Tempo de desenvolvimento do ovo até larva:
	// 1–3 dias (25–30 °C); 7–14 dias (15–20 °C);
	// 1–2 dias (30–35 °C). Referência: Doeurk et al. (2025).

	// Tempo de desenvolvimento da larva até pupa:
	// 5–10 dias (25–30 °C); 14–30 dias (15–20 °C);
	// 4–6 dias (30–35 °C). Referência: Doeurk et al. (2025).

	// Tempo de desenvolvimento da pupa até mosquito adulto:
	// 2 dias (25–30 °C); 7–14 dias (15–20 °C);
	// 1–2 dias (30–35 °C). Referência: Doeurk et al. (2025).
		if (temperatura <= 20) {
			if (estagio = 0) {
				duracao_estagio <- rnd(7, 14);
			} else if (estagio = 1) {
				duracao_estagio <- rnd(14, 30);
			} else {
				duracao_estagio <- rnd(7, 14);
			}

		} else if (temperatura < 30) {
			if (estagio = 0) {
				duracao_estagio <- rnd(1, 3);
			} else if (estagio = 1) {
				duracao_estagio <- rnd(5, 10);
			} else {
				duracao_estagio <- 2;
			}

		} else {
			if (estagio = 0) {
				duracao_estagio <- rnd(1, 2);
			} else if (estagio = 1) {
				duracao_estagio <- rnd(4, 6);
			} else {
				duracao_estagio <- rnd(1, 2);
			}

		}

	}

	init {
		do DefinirDuracao;
	}

	action Envelhecer (float qtd_chuva) {
		idade <- idade + 1;
		if (idade >= duracao_estagio) {
			if (estagio < 2) {
				estagio <- estagio + 1;
				idade <- 0;
				do DefinirDuracao;
			} else {
				poca pop <- poca_natal;
				if (!dead(pop)) {
					remove self from: pop.imaturos;
					create mosquito number: 1 {
						location <- pop.location;
						poca_natal <- pop.location;
					}

				}

				do die;
			}

		}

	}

}