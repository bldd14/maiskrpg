/*
	Created by #Fede
*/
#include <a_samp>
#include <a_mysql>
#include <Pawn.CMD>
#include <sscanf2>
#include <streamer>

//#define USE_ENG

#if defined USE_ENG
	#include "Modules/eng.lang"
#else
	#include "Modules/esp.lang"
#endif

/* Modulos */
#include "Modules/Server/Dialogs.p"

#include "Modules/Data/MySQL.p"
#include "Modules/Data/Players.p"

#include "Modules/Utils/Funcs.p"


main(){
	print(#START_MSG);
}