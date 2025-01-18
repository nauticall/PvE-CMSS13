/*
 * Platforms
 */
/obj/structure/platform
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform"
	climbable = TRUE
	anchored = TRUE
	density = TRUE
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE
	unslashable = TRUE
	climb_delay = CLIMB_DELAY_SHORT
	projectile_coverage = PROJECTILE_COVERAGE_NONE

/obj/structure/platform/stair_cut
	icon_state = "platform_stair"//icon will be honked in all dirs except (1), that's because the behavior breaks if it ain't (1)
	dir = 1
/obj/structure/platform/stair_cut/alt
	icon_state = "platform_stair_alt"
	dir = 1


/obj/structure/platform/Initialize()
	. = ..()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
			layer = MOB_LAYER
		if(WEST)
			I.pixel_x = -16
			layer = MOB_LAYER
	overlays += I

/obj/structure/platform/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform/Collided(atom/movable/AM)
	if(ismob(AM))
		do_climb(AM)
	..()

/obj/structure/platform/BlockedPassDirs(atom/movable/mover, target_dir)
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/platform/ex_act()
	return

/obj/structure/platform/attackby(obj/item/W, mob/user)
	. = ..()
	if(user.pulling)
		if(!can_climb(user))
			return
		user.visible_message(SPAN_WARNING("[user] starts dragging \the [user.pulling] onto \the [src]"),\
		SPAN_WARNING("You start dragging \the [user.pulling] onto \the [src]."))
		if(!do_after(user, 3 SECONDS * user.get_skill_duration_multiplier(SKILL_FIREMAN), INTERRUPT_ALL, BUSY_ICON_HOSTILE, user.pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(user.pulling)
			if(!can_climb(user))
				return
			var/turf/move_to_turf = get_step(get_turf(src), dir)
			user.visible_message(SPAN_WARNING("[user] finishes dragging \the [user.pulling] onto \the [src]"),\
			SPAN_WARNING("You finish dragging \the [user.pulling] onto \the [src]."))
			user.pulling.forceMove(move_to_turf)

/obj/structure/platform_decoration
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform_deco"
	anchored = TRUE
	density = FALSE
	throwpass = TRUE
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/platform_decoration/Initialize()
	. = ..()
	switch(dir)
		if (NORTH)
			layer = OBJ_LAYER+0.1
		if (SOUTH)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER+0.1
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER+0.1
		if (EAST)
			layer = MOB_LAYER+0.1
		if (WEST)
			layer = MOB_LAYER+0.1

/obj/structure/platform_decoration/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform_decoration/ex_act()
	return

//Map variants//

//Strata purple ice//
/obj/structure/platform_decoration/strata
	name = "ice rock corner"
	desc = "A solid chunk of desolate rocks and ice."
	icon_state = "strata_platform_deco"

/obj/structure/platform/strata
	name = "ice rock edge"
	desc = "A solid chunk of desolate rocks and ice. Looks like you could climb it with some difficulty."
	icon_state = "strata_platform"

//Strata wall metal platforms
/obj/structure/platform_decoration/strata/metal
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform/strata/metal
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform"

//Kutjevo metal platforms

/obj/structure/platform/kutjevo
	icon_state = "kutjevo_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform_decoration/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"


/obj/structure/platform/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

/obj/structure/platform_decoration/kutjevo/smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform/kutjevo/rock
	icon_state = "kutjevo_rock"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform_decoration/kutjevo/rock
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_deco"


/obj/structure/platform/mineral
	icon_state = "stone"
/obj/structure/platform_decoration/mineral
	icon_state = "stone_deco"

/obj/structure/platform/mineral/sandstone
	name = "sandstone platform"
	desc = "A platform supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	color = "#c6a480"

/obj/structure/platform/mineral/sandstone/runed
	name = "sandstone temple platform"
	color = "#b29082"



/obj/structure/platform_decoration/mineral/sandstone
	name = "sandstone platform corner"
	desc = "A platform corner supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	color = "#c6a480"

/obj/structure/platform/shiva/catwalk
	icon_state = "shiva"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform_decoration/shiva/catwalk
	icon_state = "shiva_deco"
	name = "raised rubber cord platform"
	desc = "Reliable steel and a polymer rubber substitute. Doesn't crack under cold weather."

/obj/structure/platform_decoration/mineral/sandstone/runed
	name = "sandstone temple platform corner"
	color = "#b29082"

/// Hybrisa Platforms

/obj/structure/platform/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform_decoration/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform/hybrisa/engineer
	icon_state = "engineer_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."
	climb_delay = 10

/obj/structure/platform_decoration/hybrisa/engineer_corner
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_deco"

/obj/structure/platform_decoration/hybrisa/engineer_cornerbits
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_platformcorners"


/obj/structure/platform/hybrisa/rockdark
	icon_state = "kutjevo_rockdark"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform_decoration/hybrisa/rockdark
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_decodark"


/obj/structure/platform/hybrisa/metalplatform1
	icon_state = "hybrisastone"
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
/obj/structure/platform_decoration/hybrisa/metalplatformdeco1
	icon_state = "hybrisastone_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."

/obj/structure/platform_decoration/hybrisa/metalplatformdeco2
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco2"

/obj/structure/platform/hybrisa/metalplatform2
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform2"

/obj/structure/platform_decoration/hybrisa/metalplatformdeco3
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco3"

/obj/structure/platform/hybrisa/metalplatform3
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform3"

/obj/structure/platform/hybrisa/metalplatform4
	icon_state = "hybrisaplatform"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/hybrisa/metalplatformdeco4
	icon_state = "hybrisaplatform_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/hybrisa/metalplatform5
	icon_state = "hybrisaplatform2"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/hybrisa/metalplatformdeco5
	icon_state = "hybrisaplatform_deco2"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/hybrisa/metalplatform6
	icon_state = "hybrisaplatform3"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/hybrisa/metalplatformstair1
	icon_state = "hybrisaplatform_stair" //icon will be honked in all dirs except (1), that's because the behavior breaks if it ain't (1)
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = 1

/obj/structure/platform/hybrisa/metalplatformstair2
	icon_state = "hybrisaplatform_stair_alt"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = 1

/obj/structure/platform_decoration/hybrisa/metalplatformdeco6
	icon_state = "hybrisaplatform_deco3"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/stone/sandstone
	name = "sandstone platform corner"
	desc = "A platform corner supporting elevated ground, made of sandstone. Has what seem to be ancient hieroglyphs on its side."
	icon_state = "sandstone_deco"
	color = "#c6a480"

/obj/structure/platform_decoration/stone/sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/sandstone/west
	dir = WEST

/obj/structure/platform_decoration/stone/runed_sandstone
	name = "sandstone temple platform corner"
	icon_state = "stone_deco"
	color = "#b29082"

/obj/structure/platform_decoration/stone/runed_sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/runed_sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/runed_sandstone/west
	dir = WEST

/// Hybrisa Platforms

/obj/structure/platform/metal/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform/metal/hybrisa/engineer
	icon_state = "engineer_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."
	climb_delay = 10
	layer = TURF_LAYER

/obj/structure/platform/metal/hybrisa/engineer/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/engineer/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/engineer/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform1
	icon_state = "hybrisametal"
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform1/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform1/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform1/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform2
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform2"

/obj/structure/platform/metal/hybrisa/metalplatform2/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform2/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform2/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform3
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform3"

/obj/structure/platform/metal/hybrisa/metalplatform3/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform3/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform3/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform4
	icon_state = "hybrisaplatform"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform4/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform4/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform4/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform5
	icon_state = "hybrisaplatform2"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform5/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform5/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform5/west
	dir = WEST

/obj/structure/platform/metal/hybrisa/metalplatform6
	icon_state = "hybrisaplatform3"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform/metal/hybrisa/metalplatform6/north
	dir = NORTH
/obj/structure/platform/metal/hybrisa/metalplatform6/east
	dir = EAST
/obj/structure/platform/metal/hybrisa/metalplatform6/west
	dir = WEST


/obj/structure/platform/stone/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform/stone/hybrisa/rockdark
	icon_state = "kutjevo_rockdark"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform/stone/hybrisa/rockdark/north
	dir = NORTH
/obj/structure/platform/stone/hybrisa/rockdark/east
	dir = EAST
/obj/structure/platform/stone/hybrisa/rockdark/west
	dir = WEST



/obj/structure/platform_decoration/metal/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform_decoration/metal/hybrisa/engineer_corner
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_deco"
	layer = TURF_LAYER

/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/engineer_corner/west
	dir = WEST


/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-Euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "engineer_platform_platformcorners"
	layer = TURF_LAYER

/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/engineer_cornerbits/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1
	icon_state = "hybrisametal_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco1/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco2"

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco2/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco3"

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco3/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4
	icon_state = "hybrisaplatform_deco"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco4/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5
	icon_state = "hybrisaplatform_deco2"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco5/west
	dir = WEST

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6
	icon_state = "hybrisaplatform_deco3"
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."

/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/north
	dir = NORTH
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/east
	dir = EAST
/obj/structure/platform_decoration/metal/hybrisa/metalplatformdeco6/west
	dir = WEST


/obj/structure/platform_decoration/stone/hybrisa
	icon_state = "hybrisa"

/obj/structure/platform_decoration/stone/hybrisa/rockdark
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1-meter-long lengths of perfectly climbable chest high walls."
	icon_state = "kutjevo_rock_decodark"

/obj/structure/platform_decoration/stone/hybrisa/rockdark/north
	dir = NORTH
/obj/structure/platform_decoration/stone/hybrisa/rockdark/east
	dir = EAST
/obj/structure/platform_decoration/stone/hybrisa/rockdark/west
	dir = WEST



/obj/structure/platform/metal/stair_cut/hybrisa_metal_left
	icon_state = "hybrisaplatform_stair"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = NORTH

/obj/structure/platform/metal/stair_cut/hybrisa_metal_right
	icon_state = "hybrisaplatform_stair_alt"
	name = "raised metal platform"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	dir = NORTH

/obj/structure/platform_decoration/stone/runed_sandstone/north
	dir = NORTH
/obj/structure/platform_decoration/stone/runed_sandstone/east
	dir = EAST
/obj/structure/platform_decoration/stone/runed_sandstone/west
	dir = WEST
