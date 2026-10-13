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
    int altura <- rnd(10, 50);

    list<string> estados <- [
        "Saudavel",
        "Exposto",
        "infectado",
        "Recuperado"
    ];

    int estadoAtual <- 0;
    int dias_Infectado <- 0;

    float prob_transmissao <- 0.275;
    int periodo_incubacao <- rnd(5, 7);
    int periodo_viral <- rnd(4, 5);
    int periodo_recuperacao <- 120;

    bool vacinado <- false;
    rgb cor <- #green;

    // Localização e deslocamento
    point residencia;
    point trabalho;
    point destino;

    bool em_movimento <- false;

    float velocidade <- 10.0;
    float velocidade_parado <- 10.0;
    float velocidade_andando <- 300.0;

    // Trabalho
    int hora_entrada <- 8;
    int hora_saida <- rnd(16, 24);

    aspect default {
        draw circle(150) color: cor;
    }

    // --------------------------------------------------
    // Movimento
    // --------------------------------------------------

    reflex andar {

        if (
            (hora >= 5 and hora < 8)
            or (hora >= 16 and hora < 19)
        ) {

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

    string obter_regiao(point pos) {
        loop regiao over: ambiente {
            if (regiao.shape overlaps pos) {
                return regiao.nm_regiao_;
            }
        }

        return "";
    }

    point sortear_localizacao(string nome_regiao) {
        list<ambiente> regioes <- ambiente where (
            each.nm_regiao_ = nome_regiao
        );

        if (empty(regioes)) {
            return nil;
        }

        ambiente subprefeitura <- one_of(regioes);

        return any_location_in(subprefeitura.shape);
    }

    point sortear_destino(point pos) {
        string origem <- obter_regiao(pos);

        if (origem = "") {
            return nil;
        }

        string regiao <- sortear_regiao_destino(origem);

        return sortear_localizacao(regiao);
    }

    string sortear_regiao_destino(string origem) {
        float sorteio <- rnd(0.0, 100.0);
        string regiao <- origem;

        // Manhã: 05h às 08h
        if (hora >= 5 and hora < 9) {

            if (origem = "Centro") {
                if (sorteio < 58.8) {
                    regiao <- "Centro";
                } else if (sorteio < 62.7) {
                    regiao <- "Norte";
                } else if (sorteio < 75.5) {
                    regiao <- "Sul";
                } else if (sorteio < 87.2) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Norte") {
                if (sorteio < 7.3) {
                    regiao <- "Centro";
                } else if (sorteio < 78.4) {
                    regiao <- "Norte";
                } else if (sorteio < 82.8) {
                    regiao <- "Sul";
                } else if (sorteio < 87.5) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Sul") {
                if (sorteio < 6.7) {
                    regiao <- "Centro";
                } else if (sorteio < 7.7) {
                    regiao <- "Norte";
                } else if (sorteio < 83.6) {
                    regiao <- "Sul";
                } else if (sorteio < 86.8) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Leste") {
                if (sorteio < 7.3) {
                    regiao <- "Centro";
                } else if (sorteio < 9.0) {
                    regiao <- "Norte";
                } else if (sorteio < 14.3) {
                    regiao <- "Sul";
                } else if (sorteio < 93.6) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Oeste") {
                if (sorteio < 10.1) {
                    regiao <- "Centro";
                } else if (sorteio < 15.1) {
                    regiao <- "Norte";
                } else if (sorteio < 27.8) {
                    regiao <- "Sul";
                } else if (sorteio < 29.9) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }
            }

        // Tarde: 16h às 19h
        } else if (hora >= 16 and hora < 20) {

            if (origem = "Centro") {
                if (sorteio < 26.4) {
                    regiao <- "Centro";
                } else if (sorteio < 41.7) {
                    regiao <- "Norte";
                } else if (sorteio < 62.3) {
                    regiao <- "Sul";
                } else if (sorteio < 89.1) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Norte") {
                if (sorteio < 2.0) {
                    regiao <- "Centro";
                } else if (sorteio < 90.1) {
                    regiao <- "Norte";
                } else if (sorteio < 92.0) {
                    regiao <- "Sul";
                } else if (sorteio < 96.4) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Sul") {
                if (sorteio < 2.6) {
                    regiao <- "Centro";
                } else if (sorteio < 4.8) {
                    regiao <- "Norte";
                } else if (sorteio < 89.5) {
                    regiao <- "Sul";
                } else if (sorteio < 96.1) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Leste") {
                if (sorteio < 1.7) {
                    regiao <- "Centro";
                } else if (sorteio < 4.1) {
                    regiao <- "Norte";
                } else if (sorteio < 7.0) {
                    regiao <- "Sul";
                } else if (sorteio < 86.3) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }

            } else if (origem = "Oeste") {
                if (sorteio < 5.5) {
                    regiao <- "Centro";
                } else if (sorteio < 21.5) {
                    regiao <- "Norte";
                } else if (sorteio < 48.3) {
                    regiao <- "Sul";
                } else if (sorteio < 60.8) {
                    regiao <- "Leste";
                } else {
                    regiao <- "Oeste";
                }
            }
        }

        return regiao;
    }

    // --------------------------------------------------
    // Estado de saúde
    // --------------------------------------------------

    action MudarEstado {
        estadoAtual <- estadoAtual + 1;

        if (estadoAtual > 3) {
            estadoAtual <- 0;
            dias_Infectado <- 0;
        }

        switch estadoAtual {
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

        if (estadoAtual > 0) {
            dias_Infectado <- dias_Infectado + 1;
        }

        if (
            estadoAtual = 1
            and dias_Infectado >= periodo_incubacao
        ) {
            do MudarEstado;

            if (rnd(1, 10000) <= 2) {
                do die;
            }
        }

        if (
            estadoAtual = 2
            and dias_Infectado >= periodo_incubacao + periodo_viral
        ) {
            do MudarEstado;
        }

        if (
            estadoAtual = 3
            and dias_Infectado >= periodo_incubacao
                + periodo_viral + periodo_recuperacao
        ) {
            do MudarEstado;
            cor <- #green;
            dias_Infectado <- 0;
        }

        dias_Infectado <- dias_Infectado + 1;

        if (idade > espectativaDeVida) {
            float PorcentagemExtra <-
                (idade - espectativaDeVida) / 365.0;

            if (rnd(1, 48300) = 1 + 484 * PorcentagemExtra) {
                do die;
                mortos_por_dengue <- mortos_por_dengue + 1;
            }
        }

        if (rnd(1, 48300) = 1) {
            do die;
        }

        idade <- idade + 1;
    }

    // --------------------------------------------------
    // Nascimento
    // --------------------------------------------------

    action Nascer {
        if (rnd(1, 35714) = 1) {
            create pessoa number: 1 with: [
                idade:: 0,
                location:: any_location_in(one_of(ambiente).shape)
            ];
        }
    }
}
