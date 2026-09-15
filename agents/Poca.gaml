/**
* Name: Poca
* Based on the internal empty template. 
* Author: henrique
* Tags: 
*/


model Poca

/* Insert your model definition here */

species poca 	
{
	rgb cor <- #blue;
	
    int qtd_ovos <- 0;
	int max_ovos <- 100;
	
	
	
	aspect default {
		draw circle(1) color: cor;
	}
}