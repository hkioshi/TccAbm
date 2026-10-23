
/**
 * Name: Poca
 * Author: henrique
 */

model Poca

import "Imaturo.gaml"
import "../globals/globals.gaml"

species poca {

    rgb cor <- #blue;
    int tamanho <- 1;
    list<imaturo> imaturos <- [];

    action Envelhecer (float qtd_chuva) {

        /*
         * SEM CHUVA
         * A poça seca conforme a temperatura.
         */
        if (qtd_chuva = 0) {

            if (temperatura > 30) {
                tamanho <- tamanho - 2;
            } else {
                tamanho <- tamanho - 1;
            }

            /*
             * A poça não pode ter tamanho negativo.
             */
            if (tamanho < 0) {
                tamanho <- 0;
            }

        } else if (qtd_chuva <= 10) {
            tamanho <- tamanho + 1;

        } else if (qtd_chuva <= 30) {
            tamanho <- tamanho + 2;

        } else if (qtd_chuva <= 60) {
            tamanho <- tamanho + 3;

        } else {
            tamanho <- tamanho + 4;
        }

        /*
         * Limite máximo da poça.
         */
        if (tamanho > 5) {
            tamanho <- 5;
        }

        /*
         * Cada nível suporta 20 ovos.
         */
        int capacidade <- tamanho * 20;

        /*
         * Os ovos excedentes morrem.
         */
        if (length(imaturos) > capacidade) {
            int matar <- length(imaturos) - capacidade;

            loop i from: 1 to: matar {
                if (length(imaturos) > 0) {
                    ask one_of(imaturos) {
                        do die;
                    }
                }
            }
        }

        /*
         * A poça desaparece quando chega a zero.
         */
        if (tamanho = 0) {
            ask imaturos {
                do die;
            }

            do die;
        }
    }

    aspect default {
        draw circle(250) color: cor;
    }
}
