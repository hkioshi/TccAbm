model Main
import "agents/Mosquito.gaml"
import "agents/Pessoa.gaml"
import "agents/Ambiente.gaml"
import "agents/Poca.gaml"
import "globals/globals.gaml"

grid mapa width: 20 height: 20
{
	rgb cor <- #green;
	aspect default { draw shape color: cor; }
}

experiment MeuExperimento type: gui
{
	action clicar
	{
		point pos <- #user_location;
		if (!empty(mapa overlapping pos))
		{
			create mosquito number: 100
			{
				poca_natal <- pos;
				location <- pos;
				infectado <- rnd(0.0, 1.0) < 0.1;
				cor <- infectado ? #red : #black;
			}
		}
	}

	output
	{
		display mundo type: 2d
		{
			grid mapa;
			species ambiente aspect: default transparency: 0.5;
			species poca;
			species pessoa;
			species mosquito;

			event #mouse_down action: clicar;
		}

		monitor "Quantidade pessoas" value: length(pessoa);
		monitor "Quantidade mosquito" value: length(mosquito);
		monitor "Quantidade ovos" value: length(ovo);
		monitor "Dia" value: dia;
		monitor "Temperatura" value: temperatura;
	}
}