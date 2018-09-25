#include <YSI\y_hooks>
#include <YSI\y_iterate>

new VehicleFuel[MAX_VEHICLES];


hook OnGameModeInit(){
	SetTimer("Gasolina", 1000*(random(5)+1), true);
}

hook OnVehicleSpawn(vehicleid){
	VehicleFuel[vehicleid] = GetVehicleMaxFuel(GetVehicleModel(vehicleid));
	return 1;
}

funcion GetVehicleMaxFuel(m){
	if(m == 417 || m == 425 || m == 487 || m == 488 || m == 497) return 690;
	else if(m == 447 || m == 469) return 550;
	else if(m == 476 || m == 511 || m == 512 || m == 593 || m == 519) return 700;
	else if(m == 513 || m == 460) return 490;
	else if(m == 548 || m == 563 || m == 520 || m == 553) return 810;
	else if(m == 592 || m == 577) return 950; 
	else return 500;
}

funcion Gasolina(){
	new engine, lights, alarm, doors, bonnet, boot, objective;
	foreach(new veh : Vehicle){
		GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);		
		if(engine == 1){
			if(VehicleFuel[veh] > 0){
				VehicleFuel[veh]--;
			}
		}
	}
	return 1;
}