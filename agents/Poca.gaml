/**
 * Name: Poca
 * Based on the internal empty template.
 * Author: henrique
 * Tags:
 */

model Poca

import "Ovo.gaml"
import "../globals/globals.gaml"

species poca
{
    rgb cor <- #blue;
    int tamanho <- 1;
    list<ovo> ovos <- [];

    action Envelhecer(float qtd_chuva)
    {
        /*
         * SEM CHUVA
         * A poça diminui e pode perder ovos
         */
        if (qtd_chuva = 0) {

            tamanho <- tamanho - 2;

            /*
             * A poça não pode ter tamanho negativo.
             */
            if (tamanho < 0) {
                tamanho <- 0;
            }

            /*
             * Cada nível da poça suporta 20 ovos.
             */
            int capacidade <- tamanho * 20;

            /*
             * Se houver mais ovos do que a capacidade,
             * os ovos excedentes morrem.
             */
            if (length(ovos) > capacidade) {

                int matar <- length(ovos) - capacidade;

                loop i from: 1 to: matar {
                    ask one_of(ovos) {
                        do die;
                    }
                }
            }

            /*
             * Se a poça chegou a tamanho 0,
             * ela desaparece.
             */
            if (tamanho = 0) {
                do die;
            }
        }

        /*
         * CHUVA DE 1 A 10 mm
         */
        else if (qtd_chuva <= 10) {
            tamanho <- tamanho + 1;
        }

        /*
         * CHUVA DE 11 A 30 mm
         */
        else if (qtd_chuva <= 30) {
            tamanho <- tamanho + 2;
        }

        /*
         * CHUVA DE 31 A 60 mm
         */
        else if (qtd_chuva <= 60) {
            tamanho <- tamanho + 3;
        }

        /*
         * CHUVA ACIMA DE 60 mm
         */
        else {
            tamanho <- tamanho + 4;
        }

        /*
         * Limite máximo da poça.
         */
        if (tamanho > 5) {
            tamanho <- 5;
        }
    }

    // Poca.gaml
		aspect default { draw circle(300) color: #cyan; }
}