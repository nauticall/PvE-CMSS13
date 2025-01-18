/obj/structure/machinery/door/poddoor/two_tile
	dir = EAST
	icon = 'icons/obj/structures/doors/1x2blast_hor.dmi'
	shutter_length = 2
	var/obj/structure/machinery/door/poddoor/filler_object/f1
	var/obj/structure/machinery/door/poddoor/filler_object/f2

/obj/structure/machinery/door/poddoor/two_tile/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/Initialize()
	. = ..()
	f1 = new/obj/structure/machinery/door/poddoor/filler_object (loc)
	f2 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(src,dir))
	f1.density = density
	f2.density = density
	f1.set_opacity(opacity)
	f2.set_opacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/Destroy()
	QDEL_NULL(f1)
	QDEL_NULL(f2)
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/open()
	if(!density)
		return
	if(operating) //doors can still open when emag-disabled
		return

	operating = TRUE
	start_opening()

	addtimer(CALLBACK(src, PROC_REF(open_fully)), openspeed)
	return TRUE

/obj/structure/machinery/door/poddoor/two_tile/proc/start_opening()
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	set_opacity(0)
	f1.set_opacity(0)
	f2.set_opacity(0)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_opening()
	f3.set_opacity(0)
	f4.set_opacity(0)
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/open_fully()
	density = FALSE
	f1.density = FALSE
	f2.density = FALSE

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), 15 SECONDS)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open_fully()
	f3.density = FALSE
	f4.density = FALSE
	..()

/obj/structure/machinery/door/poddoor/two_tile/close()
	if(density)
		return
	if(operating)
		return
	start_closing()
	addtimer(CALLBACK(src, PROC_REF(close_fully)), openspeed)
	return

/obj/structure/machinery/door/poddoor/two_tile/proc/start_closing()
	operating = 1
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"

	density = TRUE
	f1.density = TRUE
	f2.density = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_closing()
	f3.density = TRUE
	f4.density = TRUE
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/close_fully()
	set_opacity(initial(opacity))
	f1.set_opacity(initial(opacity))
	f2.set_opacity(initial(opacity))
	operating = 0

/obj/structure/machinery/door/poddoor/two_tile/four_tile/close_fully()
	f3.set_opacity(initial(opacity))
	f4.set_opacity(initial(opacity))
	..()

/obj/structure/machinery/door/poddoor/two_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'

/obj/structure/machinery/door/poddoor/two_tile/vertical/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile
	icon = 'icons/obj/structures/doors/1x4blast_hor.dmi'
	shutter_length = 4
	var/obj/structure/machinery/door/poddoor/filler_object/f3
	var/obj/structure/machinery/door/poddoor/filler_object/f4

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Initialize()
	. = ..()
	f3 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f2,dir))
	f4 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f3,dir))
	f3.density = density
	f4.density = density
	f3.set_opacity(opacity)
	f4.set_opacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Destroy()
	QDEL_NULL(f3)
	QDEL_NULL(f4)
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x4blast_vert.dmi'

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/secure
	icon = 'icons/obj/structures/doors/1x4blast_hor_secure.dmi'
	openspeed = 17
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/secure/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/pivot/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(direction_change_move))

/obj/structure/machinery/door/poddoor/two_tile/four_tile/pivot/proc/direction_change_move(source, old_dir, new_dir)
	if(old_dir == new_dir)
		return
	x -= shutter_length - 1

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/secure
	icon = 'icons/obj/structures/doors/1x4blast_vert_secure.dmi'
	openspeed = 17
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/secure/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/secure
	icon = 'icons/obj/structures/doors/1x2blast_hor.dmi'
	openspeed = 17
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/vertical/secure
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'
	openspeed = 17
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/almayer
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	openspeed = 4 //shorter open animation.
	vehicle_resistant = TRUE
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/poddoor/almayer/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/white/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/Initialize()
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, relativewall_neighbours)), 10)

/obj/structure/machinery/door/poddoor/almayer/locked
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/almayer/locked/attackby(obj/item/C as obj, mob/user as mob)
	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		return
	..()

/obj/structure/machinery/door/poddoor/almayer/closed
	density = TRUE
	opacity = TRUE

/obj/structure/machinery/door/poddoor/almayer/planet_side_blastdoor
	density = TRUE
	opacity = TRUE

// Hybrisa Shutters

/obj/structure/machinery/door/poddoor/hybrisa
	icon = 'icons/obj/structures/doors/hybrisashutters.dmi'
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"
	openspeed = 4

/obj/structure/machinery/door/poddoor/almayer/hybrisa/open_shutters/Initialize()
	. = ..()
	if(opacity)
		set_opacity(0)

/obj/structure/machinery/door/poddoor/almayer/hybrisa/open_shutters
	name = "\improper Shutters"
	desc = null
	icon = 'icons/obj/structures/doors/hybrisashutters.dmi'
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"
	opacity = FALSE
	vehicle_resistant = FALSE

/obj/structure/machinery/door/poddoor/almayer/hybrisa/shutters
	name = "\improper Shutters"
	desc = null
	icon = 'icons/obj/structures/doors/hybrisashutters.dmi'
	icon_state = "shutter1"
	base_icon_state = "shutter"
	vehicle_resistant = FALSE

/obj/structure/machinery/door/poddoor/hybrisa/white
	name = null
	desc = "That looks like it doesn't open easily."
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"
	unslashable = TRUE

/obj/structure/machinery/door/poddoor/hybrisa/secure_red_door
	desc = "That looks like it doesn't open easily."
	icon_state = "pdoor1"
	base_icon_state = "pdoor"
	unslashable = TRUE
