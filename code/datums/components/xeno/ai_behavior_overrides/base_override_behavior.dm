GLOBAL_LIST_EMPTY(all_ai_behavior_overrides)

/datum/component/ai_behavior_override

	/// Icon file for the behavior attached to parent as game masters will see it
	var/behavior_icon = 'icons/landmarks.dmi'

	/// Specific icon state for the behavior attached to parent as game masters will see it
	var/behavior_icon_state = "x2"

	/// The actual image holder that sits on parent for game masters
	var/image/behavior_image

/datum/component/ai_behavior_override/Initialize(...)
	. = ..()

	GLOB.all_ai_behavior_overrides += src

	behavior_image = new(behavior_icon, parent, behavior_icon_state, layer = ABOVE_FLY_LAYER)

	for(var/client/game_master in GLOB.game_masters)
		game_master.images += behavior_image

/datum/component/ai_behavior_override/Destroy(force, silent, ...)
	GLOB.all_ai_behavior_overrides -= src

	for(var/client/game_master in GLOB.game_masters)
		game_master.images -= behavior_image

	QDEL_NULL(behavior_image)

	. = ..()

/// Override this to check if we want our behavior to be valid for the checked_xeno, passes the common factor of "distance" which is the distance between the checked_xeno and src parent
/datum/component/ai_behavior_override/proc/check_behavior_validity(mob/living/carbon/xenomorph/checked_xeno, distance)
	return FALSE

/// Processes what we want this behavior to do, return FALSE if we want to continue in the process_ai() proc or TRUE if we want to handle everything and have process_ai() return
/datum/component/ai_behavior_override/proc/process_override_behavior(mob/living/carbon/xenomorph/processing_xeno, delta_time)
	SHOULD_NOT_SLEEP(TRUE)

	return FALSE
