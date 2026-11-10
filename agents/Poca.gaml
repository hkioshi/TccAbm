
/**
 * Name: Poca
 * Author: henrique
 */
model Poca

import "Imaturo.gaml"
import "../globals/globals.gaml"
import "../globals/variaveis.gaml"
species poca {
	bool permanente <- false;
	rgb cor <- #blue;

	// Nível de água da poça
	float nivel_agua <- 5.0;

	// Capacidade máxima de imaturos
	int capacidade <- 20;
	list<imaturo> imaturos <- [];

	action Envelhecer (float qtd_chuva) {
		if (qtd_chuva = 0) {
			if (temperatura > 30) {
				nivel_agua <- nivel_agua - 2.0;
			} else {
				nivel_agua <- nivel_agua - 1.0;
			}

		} else if (qtd_chuva <= 10) {
			nivel_agua <- nivel_agua + 1.0;
		} else if (qtd_chuva <= 30) {
			nivel_agua <- nivel_agua + 2.0;
		} else if (qtd_chuva <= 60) {
			nivel_agua <- nivel_agua + 3.0;
		} else {
			nivel_agua <- nivel_agua + 4.0;
		}

		// Limites do nível da água
		if (nivel_agua > 10.0) {
			nivel_agua <- 10.0;
		}

		// Criadouros permanentes nunca secam completamente
		if (permanente) {
			
			if (nivel_agua < 3.0) {
				nivel_agua <- 3.0;
			}

		} else {
			if (nivel_agua < 0.0) {
				nivel_agua <- 0.0;
			}

		}

		// Capacidade proporcional ao nível da água
		capacidade <- int(nivel_agua * 2);

		// Limita os imaturos à capacidade
		if (length(imaturos) > capacidade) {
			int quantidade_excedente <- length(imaturos) - capacidade;
			loop i from: 1 to: quantidade_excedente {
				if (length(imaturos) > 0) {
					ask one_of(imaturos) {
						do die;
					}

				}

			}

		} }

	aspect default {
		draw circle(250) color: cor;
	} }