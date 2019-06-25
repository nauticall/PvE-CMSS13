
/proc/power_failure(var/announce = 1)
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != 3) // Ship only
			continue
		S.last_charge = S.charge
		S.last_output = S.output
		S.last_online = S.online
		S.charge = 0
		S.output = 0
		S.online = 0
		S.updateicon()
		S.power_change()

	for(var/obj/machinery/power/apc/C in machines)
		if(C.cell && C.z == 3)
			C.cell.charge = 0

	playsound_z(3, 'sound/effects/powerloss.ogg')

	sleep(100)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in the ship power system. As a precaution, power must be shut down for an indefinite duration.", "Critical Power Failure", new_sound = 'sound/AI/poweroff.ogg')

/proc/power_restore(var/announce = 1)
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != 3)
			continue
		S.charge = S.capacity
		S.output = S.output_level_max
		S.online = 1
		S.updateicon()
		S.power_change()

	for(var/obj/machinery/power/apc/C in machines)
		if(C.cell && C.z == 3)
			C.cell.charge = C.cell.maxcharge

	sleep(100)
	if(announce)
		command_announcement.Announce("Power has been restored. Reason: Unknown.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')

/proc/power_restore_quick(var/announce = 1)

	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != 3) // Ship only
			continue
		S.charge = S.capacity
		S.output = S.output_level_max
		S.online = 1
		S.updateicon()
		S.power_change()

	sleep(100)
	if(announce)
		command_announcement.Announce("Power has been restored. Reason: Unknown.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')

/proc/power_restore_everything(var/announce = 1)

	for(var/obj/machinery/power/smes/S in machines)
		S.charge = S.capacity
		S.output = S.output_level_max
		S.online = 1
		S.updateicon()
		S.power_change()

	for(var/obj/machinery/power/apc/C in machines)
		if(C.cell)
			C.cell.charge = C.cell.maxcharge

	sleep(100)
	if(announce)
		command_announcement.Announce("Power has been restored. Reason: Unknown.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')

/proc/power_restore_ship_reactors(var/announce = 1)
	for(var/obj/machinery/power/fusion_engine/FE in machines)
		FE.buildstate = 0
		FE.is_on = 1
		FE.fusion_cell = new
		FE.power_gen_percent = 98
		FE.update_icon()
		FE.start_processing()
		FE.power_change()

	sleep(100)
	if(announce)
		command_announcement.Announce("Power has been restored. Reason: Unknown.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
