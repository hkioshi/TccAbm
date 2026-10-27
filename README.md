# Simulação Baseada em Agentes da Propagação da Dengue na Cidade de São Paulo

## Índice

- [1. Sobre o projeto](#1-sobre-o-projeto)
- [2. Objetivos](#2-objetivos)
- [3. Tecnologias utilizadas](#3-tecnologias-utilizadas)
- [4. Estrutura do projeto](#4-estrutura-do-projeto)
- [5. Arquitetura do modelo](#5-arquitetura-do-modelo)
- [6. Actions e Reflexos por Arquivo](#6-actions-e-reflexos-por-arquivo)
  - [6.1. Main.gaml](#61-maingaml)
  - [6.2. Pessoa.gaml](#62-pessoagaml)
  - [6.3. Mosquito.gaml](#63-mosquitogaml)
  - [6.4. Ambiente.gaml](#64-ambientegaml)
  - [6.5. Poca.gaml](#65-pocagaml)
  - [6.6. globals.gaml](#66-globalsgaml)
- [7. Dados climáticos e geográficos](#7-dados-climáticos-e-geográficos)
- [8. Parâmetros experimentais](#8-parâmetros-experimentais)
- [9. Execução do projeto](#9-execução-do-projeto)
- [10. Resultados e indicadores](#10-resultados-e-indicadores)
- [11. Reprodutibilidade](#11-reprodutibilidade)
- [12. Limitações](#12-limitações)
- [13. Autoria](#13-autoria)
- [14. Licença](#14-licença)

---

## 1. Sobre o projeto

Este projeto desenvolve uma simulação baseada em agentes (*Agent-Based Modeling — ABM*) para representar a dinâmica de propagação da dengue na cidade de São Paulo, utilizando a plataforma GAMA.

O modelo representa a interação entre seres humanos, mosquitos transmissores e elementos ambientais, considerando estados epidemiológicos, condições climáticas e regras de comportamento definidas na implementação.

## 2. Objetivos

### Objetivo geral

Desenvolver um modelo baseado em agentes para simular a propagação da dengue na cidade de São Paulo.

### Objetivos específicos

- Representar os estados epidemiológicos da população humana.
- Modelar os estados epidemiológicos dos mosquitos.
- Incorporar dados climáticos à dinâmica ambiental.
- Representar a formação e a secagem de poças.
- Permitir a configuração de parâmetros experimentais.
- Registrar indicadores para análise dos resultados.

## 3. Tecnologias utilizadas

- **GAMA Platform:** execução e visualização da simulação.
- **GAML:** linguagem de modelagem dos agentes e do ambiente.
- **Python:** preparação dos dados climáticos, quando aplicável.
- **CSV:** armazenamento dos dados de entrada e dos resultados.
- **Dados geográficos:** representação espacial do território estudado.

## 4. Estrutura do projeto

A estrutura abaixo é ilustrativa e deve ser ajustada à organização real do repositório.

```text
TccAbm/
├── Main.gaml
├── agents/
│   ├── Pessoa.gaml
│   ├── Mosquito.gaml
│   ├── Ambiente.gaml
│   └── Poca.gaml
├── globals/
│   └── globals.gaml
├── Gis/
│   └── arquivos geográficos
├── services/
│   └── arquivos/
│       └── clima_2023_2025.csv
├── resultados.csv
└── README.md
```

## 5. Arquitetura do modelo

### 5.1. Pessoa

Representa os indivíduos da população humana. O modelo utiliza estados epidemiológicos correspondentes à estrutura SEIR:

Suscetível (S): pode adquirir a infecção.

Exposto (E): encontra-se na fase de incubação.

Infectado (I): encontra-se na fase infecciosa, conforme as regras do modelo.

Recuperado (R): concluiu as etapas anteriores da progressão epidemiológica.

A implementação também contém regras relacionadas à movimentação, ao envelhecimento e ao nascimento de indivíduos.

### 5.2. Mosquito

Representa os mosquitos transmissores da dengue, utilizando os estados epidemiológicos SEI:

Suscetível (S): ainda não infectado.

Exposto (E): infectado, mas ainda não transmissor.

Infectado (I): pode transmitir o vírus segundo as regras implementadas.

### 5.3. Ambiente

Representa os elementos ambientais e espaciais utilizados pela simulação. Suas responsabilidades específicas devem ser descritas conforme as regras existentes no arquivo Ambiente.gaml.

### 5.4. Poça

Representa possíveis criadouros de mosquitos. A dinâmica pode incluir formação, variação de tamanho e secagem em função das condições ambientais, conforme a implementação de Poca.gaml.
## 6. Actions e Reflexos por Arquivo

### 6.1. Main.gaml

- **Experimento:** define os parâmetros e as configurações utilizados na execução da simulação.

### 6.2. Pessoa.gaml

- **`MudarEstado`:** avança o estado epidemiológico do indivíduo e atualiza sua representação visual.
- **`Envelhecer`:** atualiza a idade, controla a progressão dos estados epidemiológicos e aplica regras de mortalidade.
- **`Nascer`:** cria novos indivíduos conforme uma condição probabilística.
- **Reflexo `andar`:** controla a movimentação dos indivíduos entre destinos e regiões do ambiente.

### 6.3. Mosquito.gaml

- **Actions:** documentar os procedimentos declarados no arquivo, conforme suas responsabilidades no modelo.
- **Reflexos:** documentar os comportamentos automáticos relacionados ao ciclo de vida, à movimentação e à dinâmica epidemiológica, conforme implementados.

### 6.4. Ambiente.gaml

- **Actions:** documentar as operações auxiliares declaradas no arquivo.
- **Reflexos:** documentar os comportamentos automáticos relacionados à atualização das condições ambientais, caso existam.

### 6.5. Poca.gaml

- **Actions:** documentar os procedimentos declarados para a administração das poças, caso existam.
- **Reflexos:** documentar os comportamentos automáticos relacionados à formação, à variação de tamanho e à secagem das poças, conforme implementados.

### 6.6. globals.gaml

- **`Relatorio`:** registra indicadores epidemiológicos e ambientais da simulação no arquivo `resultados.csv`, conforme os campos definidos no procedimento.

## 7. Dados climáticos e geográficos

O modelo utiliza dados climáticos e geográficos para representar as condições ambientais e a distribuição espacial da população.

A documentação definitiva deve especificar as fontes dos dados, o período analisado, as variáveis utilizadas, as unidades de medida e os procedimentos de tratamento e distribuição espacial.

## 8. Parâmetros experimentais

Os parâmetros experimentais permitem configurar diferentes cenários de simulação. Entre os parâmetros utilizados ou previstos estão:

- Velocidade do tempo simulado.
- Percentual de indivíduos vacinados.
- Eficácia da vacinação.
- Semente aleatória.
- Quantidade inicial de mosquitos.

Os valores padrão e os intervalos permitidos devem corresponder à implementação atual.

## 9. Execução do projeto

### Requisitos

- Plataforma GAMA compatível com o projeto.
- Arquivos do modelo.
- Dados climáticos e geográficos necessários.

### Procedimento

1. Abrir a plataforma GAMA.
2. Importar ou abrir o projeto.
3. Conferir os caminhos dos arquivos de entrada.
4. Abrir o experimento principal.
5. Configurar os parâmetros disponíveis.
6. Executar a simulação.
7. Verificar os arquivos de resultados gerados.

## 10. Resultados e indicadores

Os resultados permitem acompanhar a evolução dos estados epidemiológicos e das condições ambientais ao longo da simulação.

O arquivo `resultados.csv` contém os indicadores definidos no procedimento `Relatorio`, incluindo dados temporais, climáticos, quantidades de pessoas e mosquitos por estado epidemiológico e contadores de mortalidade.

## 11. Reprodutibilidade

Para reproduzir os experimentos, devem ser registrados os parâmetros utilizados, a semente aleatória, a quantidade de réplicas e as condições de execução.

Quando forem realizadas múltiplas réplicas, os resultados devem ser organizados para permitir a comparação entre cenários.

## 12. Limitações

O modelo representa uma simplificação de um sistema epidemiológico complexo. Os resultados dependem das hipóteses, dos dados de entrada, dos parâmetros e das regras implementadas.

As limitações específicas devem ser descritas conforme o escopo, a validação e as fontes de dados do projeto.

## 13. Autoria

Projeto desenvolvido como parte do Trabalho de Conclusão de Curso em [nome do curso], na [nome da instituição].

- **Autores:** Henrique Kioshi Yamauchi | Renato Jorge Alpalhão 
- **Orientador:**
- **Ano:** 2026


