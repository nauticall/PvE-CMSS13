
/datum/equipment_preset/corpse
	name = "Corpse"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_COLONIST
	rank = JOB_COLONIST
	faction = FACTION_COLONIST
	languages = list()
	access = list(ACCESS_CIVILIAN_PUBLIC)
	skills = /datum/skills/civilian
	idtype = /obj/item/card/id/lanyard
	var/xenovictim = FALSE //Set to true to make the corpse spawn as a victim of a xeno burst

/datum/equipment_preset/corpse/load_languages(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/corpse/load_status(mob/living/carbon/human/new_human)
	. = ..(new_human)

	// These two values matter because they are checked on death for weed_food
	new_human.undefibbable = TRUE
	if(xenovictim)
		new_human.chestburst = 2

	new_human.death(create_cause_data("existing"), TRUE) //Kills the new mob
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	new_human.apply_damage(100, BRUTE)
	if(xenovictim)
		var/datum/internal_organ/organ
		var/i
		for(i in list("heart","lungs"))
			organ = new_human.internal_organs_by_name[i]
			new_human.internal_organs_by_name -= i
			new_human.internal_organs -= organ
		new_human.update_burst()
		//buckle to nest
		var/obj/structure/bed/nest/nest = locate() in get_turf(src)
		if(nest)
			new_human.buckled = nest
			new_human.setDir(nest.dir)
			nest.buckled_mob = new_human
			nest.afterbuckle(new_human)
	new_human.spawned_corpse = TRUE
	new_human.updatehealth()
	new_human.pulse = PULSE_NONE

/datum/equipment_preset/corpse/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	var/static/list/hair_colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "AUBURN" = list(77, 48, 36), "BLONDE" = list(95, 76, 44))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	if(new_human.gender == MALE)
		new_human.h_style = pick("Undercut, Top", "Partly Shaved", "CIA", "Mulder", "Medium Fade", "High Fade", "Pixie Cut Left", "Pixie Cut Right", "Coffee House Cut")
		new_human.f_style = pick("Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "3 O'clock Shadow", "3 O'clock Shadow", "3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		new_human.h_style = pick("Undercut, Top", "CIA", "Mulder", "Pixie Cut Left", "Pixie Cut Right", "Scully", "Pvt. Redding", "Bun", "Short Bangs")
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,40)

//*****************************************************************************************************/
// Civilians
/datum/equipment_preset/corpse/bluecollar
	name = "Corpse - Blue-Collar"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/corpse/bluecollar/get_assignment(mob/living/carbon/human/new_human)
	if(prob(50))
		return "Class D Inhabitant"

	return "Class C Inhabitant"

/datum/equipment_preset/corpse/bluecollar/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "undershirt"
	//back
	add_random_satchel(new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//uniform
	add_civilian_uniform(new_human)
	//jacket
	add_civilian_jacket(new_human)
	//limbs
	add_civilian_shoe(new_human)

/datum/equipment_preset/corpse/bluecollar/burst
	name = "Corpse - Blue-Collar (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/whitecollar
	name = "Corpse - White-Collar"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/corpse/whitecollar/get_assignment(mob/living/carbon/human/new_human)
	if(prob(50))
		return "Class B Inhabitant"

	return "Class A Inhabitant"

/datum/equipment_preset/corpse/whitecollar/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//back
	add_random_satchel(new_human)
	//outfit
	add_business_outfit(new_human)
	var/random_tie = rand(1,2)
	switch(random_tie)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/black(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/blue(new_human), WEAR_ACCESSORY)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/whitecollar/burst
	name = "Corpse - White-Collar (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/researcher
	name = "Corpse - Researcher"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Research Associate"
	paygrades = list(PAY_SHORT_CCMO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/researcher
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_WY_GENERAL, ACCESS_WY_COLONIAL, ACCESS_WY_RESEARCH)

/datum/equipment_preset/corpse/researcher/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	add_random_satchel(new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//uniform
	add_professionalwear(new_human)
	var/random_tie= rand(1,5)
	switch(random_tie)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/black(new_human), WEAR_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/blue(new_human), WEAR_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/green(new_human), WEAR_ACCESSORY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/purple(new_human), WEAR_ACCESSORY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/red(new_human), WEAR_ACCESSORY)
	//jacket
	var/random_researcher_suit = rand(1,5)
	switch(random_researcher_suit)
		if(1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/tan(new_human), WEAR_JACKET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest(new_human), WEAR_JACKET)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest/grey(new_human), WEAR_JACKET)
	//limb
	add_dress_shoes(new_human)

/datum/equipment_preset/corpse/researcher/burst
	name = "Corpse - Researcher (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/doctor
	name = "Corpse - Doctor"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Medical Doctor"
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/doctor
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_MEDBAY)

/datum/equipment_preset/corpse/doctor/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	add_random_satchel(new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//uniform
	add_professionalwear(new_human)
	add_tie(new_human)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	//limb
	add_dress_shoes(new_human)

/datum/equipment_preset/corpse/doctor/burst
	name = "Corpse - Doctor (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/doctor/scrubs
	name = "Corpse - Doctor, Scrubs"

/datum/equipment_preset/corpse/doctor/scrubs/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	//uniform
	var/random_scrubs= rand(1,4)
	switch(random_scrubs)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(new_human), WEAR_BODY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/lightblue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/stethoscope(new_human), WEAR_ACCESSORY)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/doctor/scrubs/burst
	name = "Corpse - Doctor, Scrubs (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/prisoner
	name = "Corpse - Prisoner"
	faction = FACTION_COLONIST
	assignment = "Inmate"
	access = list(null)
	idtype = /obj/item/card/id

/datum/equipment_preset/corpse/prisoner/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "undershirt"
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/prison_boiler(new_human), WEAR_BODY)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/prisoner/burst
	name = "Corpse - Prisoner (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/guard
	name = "Corpse - Security Guard, Prison"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Corrections Officer"
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/marshal
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/corpse/guard/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/corrections, WEAR_HEAD)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/boilersuit/darkblue, WEAR_BODY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/ballistic, WEAR_JACKET)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/colonist, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol, WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/alt, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_R_STORE)

/datum/equipment_preset/corpse/guard/burst
	name = "Corpse - Security Guard, Prison (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/riot
	name = "Corpse - Security Guard, UA Colonial Guard"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Colonial Militiaman"
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/marshal
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/corpse/riot/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel, WEAR_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//head
	var/maybecap = rand(1,3)
	switch(maybecap)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield, WEAR_IN_HELMET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/khaki, WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/khaki, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield, WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/ua_riot, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/riot_shield, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/khaki, WEAR_IN_BACK)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/boilersuit/khaki, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/ranks/marine/e2, WEAR_ACCESSORY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/ballistic, WEAR_JACKET)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/colonist, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol, WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
	add_worker_gloves(new_human)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/alt, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_R_STORE)

/datum/equipment_preset/corpse/riot/burst
	name = "Corpse - Security Guard, UA Colonial Guard (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/security
	name = "Corpse - Security Guard, Wey-Yu"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_COLONIST
	assignment = "Weyland-Yutani Corporate Security Officer"
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/marshal
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY)

/datum/equipment_preset/colonist/corpse/security/load_gear(mob/living/carbon/human/new_human)

	new_human.undershirt = "undershirt"
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress, WEAR_L_EAR)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/blue(new_human), WEAR_ACCESSORY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest, WEAR_JACKET)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/colonist, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol/vp70, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new 	/obj/item/ammo_magazine/pistol/vp70, WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol/alt, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/vp70, WEAR_IN_R_STORE)

/datum/equipment_preset/corpse/security/burst
	name = "Corpse - Security Guard, Wey-Yu (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/cmb
	name = "Corpse - Colonial Marshals Deputy"
	paygrades = list(PAY_SHORT_CMBD = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CMB DEP"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Office of Colonial Marshals Deputy"
	rank = JOB_CMB
	skills = /datum/skills/cmb

/datum/equipment_preset/corpse/cmb/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/spearhead, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/spearhead, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/spearhead, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full/revolver, WEAR_WAIST)

/datum/equipment_preset/corpse/cmb/burst
	name = "Corpse - Colonial Marshals Deputy (Burst)"
	xenovictim = TRUE

//*****************************************************************************************************/

//UPP
/datum/equipment_preset/corpse/upp/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	var/first_name
	var/last_name
	//gender checks
	if(new_human.gender == MALE)
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_male_upp)]"
		new_human.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")
	else
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_female_upp)]"
	//surname
	if(prob(35))
		last_name = "[capitalize(randomly_generate_chinese_word(pick(20;1, 80;2)))]"
	else
		last_name = "[pick(GLOB.last_names_upp)]"
	//put them together
	random_name = "[first_name] [last_name]"

	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,35)
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	var/static/list/hair_colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "AUBURN" = list(77, 48, 36), "BLONDE" = list(95, 76, 44))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	if(new_human.gender == MALE)
		new_human.h_style = pick("Undercut, Top", "Partly Shaved", "CIA", "Mulder", "Medium Fade", "High Fade", "Pixie Cut Left", "Pixie Cut Right", "Coffee House Cut")
		new_human.f_style = pick("Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "3 O'clock Shadow", "3 O'clock Shadow", "3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		new_human.h_style = pick("Undercut, Top", "CIA", "Mulder", "Pixie Cut Left", "Pixie Cut Right", "Scully", "Pvt. Redding", "Bun", "Short Bangs")

/datum/equipment_preset/corpse/upp
	name = "Corpse - UPP Squad Rifleman"
	faction = FACTION_UPP
	assignment = JOB_SQUAD_MARINE
	role_comm_title = "RFN"
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)
	skills = /datum/skills/pfc
	access = list(ACCESS_UPP_GENERAL)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/corpse/upp/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/bedroll, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/canteen, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	var/maybeberet = rand(1,3)
	switch(maybeberet)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/upp, WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/upp/alt, WEAR_HEAD)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/uniform = new()
	var/random_uniform = rand(1,2)
	switch(random_uniform)
		if(1)
			uniform.roll_suit_jacket(new_human)
		if(2)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid, WEAR_L_STORE)

/datum/equipment_preset/corpse/upp/burst
	name = "Corpse - UPP Squad Rifleman (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/royal_marine
	name = "Corpse - TWE Squad Rifleman"
	paygrades = list(PAY_SHORT_RMC1 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marines Rifleman"
	rank = JOB_TWE_RMC_RIFLEMAN
	skills = /datum/skills/rmc

/datum/equipment_preset/corpse/royal_marine/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/royal_marine, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/rmc, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/rmc/rmc_f90_ammo, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)

/datum/equipment_preset/corpse/royal_marine/burst
	name = "Corpse - TWE Squad Rifleman (Burst)"
	xenovictim = TRUE

/datum/equipment_preset/corpse/uscm
	name = "Corpse - USCM Squad Rifleman"
	flags = EQUIPMENT_PRESET_EXTRA
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "RFN"
	skills = /datum/skills/pfc
	minimap_icon = "private"

/datum/equipment_preset/corpse/uscm/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/corpse/uscm/burst
	name = "Corpse - USCM Squad Rifleman (Burst)"
	xenovictim = TRUE

//*****************************************************************************************************/

//Freelancer

/datum/equipment_preset/corpse/freelancer
	name = "Corpse - Freelancer"
	paygrades = list(PAY_SHORT_FL_S = JOB_PLAYTIME_TIER_0)
	rank = FACTION_FREELANCER
	idtype = /obj/item/card/id/data
	faction = FACTION_FREELANCER

/datum/equipment_preset/corpse/freelancer/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) + get_access(ACCESS_LIST_COLONIAL_ALL)

/datum/equipment_preset/corpse/freelancer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	spawn_merc_helmet(new_human)

/datum/equipment_preset/corpse/freelancer/burst
	name = "Corpse - Freelancer (Burst)"
	xenovictim = TRUE

//*****************************************************************************************************/

//FORECON

/datum/equipment_preset/corpse/forecon_spotter
	name = "Corpse - USCM Reconnaissance Spotter"
	assignment = "Reconnaissance Spotter"
	xenovictim = FALSE
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag
	role_comm_title = "FORECON"
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

/datum/equipment_preset/corpse/forecon_spotter/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/reconnaissance/uniform = new()
	var/obj/item/clothing/accessory/storage/droppouch/pouch = new()
	var/obj/item/clothing/accessory/ranks/marine/e5/pin = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,pouch)
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,pin)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/marine(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/facepaint/sniper(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio(new_human), WEAR_IN_BACK)

//*****************************************************************************************************/
///////////////////////
/////// HYBRISA ///////
///////////////////////

// Hybrisa Goon

/datum/equipment_preset/corpse/pmc/hybrisa_goon
	name = "Corpse - Weyland-Yutani - Corporate Security"
	languages = list(LANGUAGE_ENGLISH)
	assignment = JOB_WY_GOON
	rank = JOB_WY_GOON
	paygrade = "WEY-GOON"

/datum/equipment_preset/corpse/pmc/hybrisa_goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)

/datum/equipment_preset/corpse/pmc/hybrisa_goon/burst
	name = "Corpse - Burst Weyland-Yutani - Corporate Security (Goon)"
	xenovictim = TRUE

// Hybrisa Lead Goon

/datum/equipment_preset/corpse/pmc/hybrisa_goon/lead
	name = "Corpse - Weyland-Yutani - Corporate Security Lead"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrade = "WEY-GOON-L"

/datum/equipment_preset/corpse/pmc/hybrisa_goon/lead/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa/lead, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa/lead, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/p90, WEAR_IN_L_STORE)

/datum/equipment_preset/corpse/pmc/hybrisa_goon/lead/burst
	name = "Corpse - Burst Weyland-Yutani - Corporate Security Lead (Goon Lead)"
	xenovictim = TRUE

//*****************************************************************************************************/

// Civilian


/datum/equipment_preset/corpse/hybrisa
	flags = EQUIPMENT_PRESET_STUB

/datum/equipment_preset/corpse/hybrisa/civilian
	name = "Corpse - Civilian"
	assignment = "Civilian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/civilian/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,10)
	switch(random_gear)
		if(1) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
		if(2) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/industrial(new_human), WEAR_BACK)
		if(3) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/parka_green(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(4) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(5) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(6) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/hybrisa/polyester_jacket_red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(7) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/ferret(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/grey(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/khaki(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(8) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear/pink(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
		if(9) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker/red(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/bomber/red(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(10) // Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beanie/royal_marine(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber/alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/wy_joliet_shopsteward(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/royal_marine(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack(new_human), WEAR_BACK)
	..()

/datum/equipment_preset/corpse/hybrisa/civilian/burst
	name = "Corpse - Burst - Civilian"
	assignment = "Civilian"
	xenovictim = TRUE

// Office Workers

/datum/equipment_preset/corpse/hybrisa/civilian_office
	name = "Corpse - Civilian - Office Worker"
	assignment = "Civilian - Office Worker"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/civilian_office/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,6)
	switch(random_gear)
		if(1) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/stowaway(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/black(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/workwear(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
		if(4) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/brown(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(5) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/det/slob(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(6) // Colonist (Office)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/corporate/blue(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blazer(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)
	..()

/datum/equipment_preset/corpse/hybrisa/civilian_office/burst
	name = "Corpse - Burst - Civilian - Office Worker"
	assignment = "Civilian"
	xenovictim = TRUE

// Weymart

/datum/equipment_preset/corpse/hybrisa/weymart
	name = "Corpse - Civilian - Weymart Employee"
	assignment = "Civilian - Weymart Employee"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/weymart/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/weymart(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/weymart(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/weymart(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/hybrisa/weymart/burst
	name = "Corpse - Burst - Civilian - Weymart Employee"
	assignment = "Civilian - Weymart Employee"
	xenovictim = TRUE

// Sanitation

/datum/equipment_preset/corpse/hybrisa/sanitation
	name = "Corpse - Civilian - Material Reprocessing Technician"
	assignment = "Civilian - Material Reprocessing Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/sanitation/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 20) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(20 to 30) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/sanitation(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(30 to 45) // Sanitation
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
		if(45 to 50) // Sanitation (Rarer)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/durag/black(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/santiation(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/hybrisa/sanitation_utility(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather(new_human), WEAR_FACE)
	..()

/datum/equipment_preset/corpse/hybrisa/sanitation/burst
	name = "Corpse - Burst - Civilian - Material Reprocessing Technician"
	assignment = "Civilian - Material Reprocessing Technician"
	xenovictim = TRUE

// Pizza Galaxy

/datum/equipment_preset/corpse/hybrisa/pizza_galaxy
	name = "Corpse - Civilian - Pizza Galaxy Delivery Driver"
	assignment = "Civilian - Pizza Galaxy Delivery Driver"
	idtype = /obj/item/card/id/pizza
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/pizza_galaxy/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/pizza_galaxy(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/pizza_galaxy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red(new_human), WEAR_FEET)

/datum/equipment_preset/corpse/hybrisa/pizza_galaxy/burst
	name = "Corpse - Burst - Civilian - Pizza Galaxy Delivery Driver"
	assignment = "Civilian - Pizza Galaxy Delivery Driver"
	xenovictim = TRUE

// Colonial Marshals

/datum/equipment_preset/corpse/hybrisa/cmb_officer

	name = "Corpse - CMB Police Officer"
	assignment = "CMB Affiliated Officer"
	paygrade = "GS-9"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/deputy

/datum/equipment_preset/corpse/hybrisa/cmb_officer/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,10)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/cmb_officer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue, WEAR_EYES)

	switch(choice)
		if(1 to 5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/cmb_peaked_cap, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/cmb/hybrisa, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
		if(6 to 7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/cmb_cap_new, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/cmb_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/slug, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(8 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hybrisa/cmb_peaked_cap_gold, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/cmb_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower/black, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
	..()

/datum/equipment_preset/corpse/hybrisa/cmb_officer/burst

	name = "Corpse - Burst - CMB Police Officer"
	assignment = "CMB Affiliated Officer"
	xenovictim = TRUE

// KMCC Mining

/datum/equipment_preset/corpse/hybrisa/kelland_miner
	name = "Corpse - KMCC - Miner"
	assignment = "KMCC - Miner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/kelland_miner/load_gear(mob/living/carbon/human/new_human)

	var/random_gear = rand(1,85)
	switch(random_gear)
		if(1 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/red/kelland, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(50 to 70)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/red/kelland, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/kelland_mining, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(70 to 80)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/heavy, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
		if(80 to 85)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/hybrisa/kelland_mining(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest/hybrisa_kelland_alt(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hybrisa/kelland_mining_helmet, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/royal_marine/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/corpse/hybrisa/kelland_miner/burst
	name = "Corpse - Burst - KMCC - Miner"
	assignment = "KMCC - Miner"
	xenovictim = TRUE

// Medical

/datum/equipment_preset/corpse/hybrisa/medical_doctor_corpse
	name = "Corpse - Civilian - Medical Doctor"
	assignment = "Civilian - Medical Doctor"
	idtype = /obj/item/card/id/silver/clearance_badge
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/corpse/hybrisa/medical_doctor_corpse/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,45)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit, WEAR_R_STORE)

	switch(choice)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(new_human), WEAR_BODY)
		if(20 to 40)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat, WEAR_JACKET)
		if(35 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_defib_and_analyzer, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/medical_red, WEAR_JACKET)
	..()

/datum/equipment_preset/corpse/hybrisa/medical_doctor_corpse/burst
	name = "Corpse - Burst - Civilian - Medical Doctor"
	assignment = "Civilian - Medical Doctor"
	xenovictim = TRUE

// Science

// Xenobiologist

/datum/equipment_preset/corpse/hybrisa/scientist_xenobiologist
	name = "Corpse - Xenobiologist"
	assignment = "Xenobiologist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist

/datum/equipment_preset/corpse/hybrisa/scientist_xenobiologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,50)
	switch(random_gear)
		if(1 to 20)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup, WEAR_FEET)
		if(20 to 45)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular, WEAR_EYES)
		if(45 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/hybrisa/civilian_vest, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
	..()

/datum/equipment_preset/corpse/hybrisa/scientist_xenobiologist/burst
	name = "Corpse - Burst - Xenobiologist"
	assignment = "Xenobiologist"
	xenovictim = TRUE

// Xenoarchaeologist

/datum/equipment_preset/corpse/hybrisa/scientist_xenoarchaeologist
	name = "Corpse - Xenoarchaeologist"
	assignment = "Xenoarchaeologist"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist

/datum/equipment_preset/corpse/hybrisa/scientist_xenoarchaeologist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,55)
	switch(random_gear)
		if(1 to 25)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/researcher, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular, WEAR_EYES)
		if(25 to 35)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, WEAR_IN_BACK)
		if(35 to 50)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio/alt, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, WEAR_IN_BACK)
		if(50 to 55)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa, WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit/wy_bio, WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown, WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/brown, WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood/wy_bio, WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/spade, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, WEAR_IN_BACK)
	..()

/datum/equipment_preset/corpse/hybrisa/scientist_xenoarchaeologist/burst
	name = "Corpse - Burst - Xenoarchaeologist"
	assignment = "Xenoarchaeologist"
	xenovictim = TRUE

//*****************************************************************************************************/
