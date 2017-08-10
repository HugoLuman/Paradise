/datum/species/yin
	name = "Yin"
	name_plural = "Yini"
	language = "Yinnish"
	icobase = 'icons/mob/human_races/r_pilot.dmi'
	deform = 'icons/mob/human_races/r_pilot.dmi'
	path = /mob/living/carbon/human/yin
	default_language = "Galactic Common"
	unarmed_type = /datum/unarmed_attack/claws
	blood_color = "#1F181F"
	flesh_color = "#AAAAAA"
	has_organ = list(
		"brain" = /obj/item/organ/internal/brain/yinslug,
		"reactor" = /obj/item/organ/internal/reactor,
		"optics" = /obj/item/organ/internal/eyes/optical_sensor
		)
	vision_organ = /obj/item/organ/internal/eyes/optical_sensor
	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/yin),
		"groin" =  list("path" = /obj/item/organ/external/groin/yin),
		"head" =   list("path" = /obj/item/organ/external/head/yin),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/yin),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/yin),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/yin),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/yin),
		"l_hand" = list("path" = /obj/item/organ/external/hand/yin),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/yin),
		"l_foot" = list("path" = /obj/item/organ/external/foot/yin),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/yin)
		)

	species_traits = list(NO_BREATHE, NO_SCAN, NO_BLOOD, NO_PAIN, NO_DNA, VIRUSIMMUNE, NOTRANSSTING)
	clothing_flags = HAS_UNDERWEAR | HAS_UNDERSHIRT | HAS_SOCKS
	bodyflags = HAS_SKIN_COLOR | ALL_RPARTS
	tox_mod = 0
	clone_mod = 0
	oxy_mod = 0
	can_revive_by_healing = 1
	dietflags = 0
	reagent_tag = PROCESS_SYN
	suicide_messages = list(
		"is shutting down life support!",
		"is overloading their controls!!",
		"is sticking their fingers through their windscreen!",
		"is overheating the compartment!")

	//death_message = "stops moving, their pneumatics falling silent as the indicator lights dim out across their body..."

	species_abilities = list(
		/mob/living/carbon/human/proc/eject_from_body
		)

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 540
	heat_level_3 = 600
	heat_level_3_breathe = 600

/datum/species/yin/handle_life(var/mob/living/carbon/human/H)
	var/rads = H.radiation/10
	H.adjustBrainLoss(rads)

/datum/species/yin/handle_death(var/mob/living/carbon/human/H, gibbed)
	var/obj/item/organ/internal/E = H.get_int_organ(/obj/item/organ/internal/brain/yinslug)
	if(E && !gibbed)
		E.remove(src,special = 2)
		//var/mob/living/Pilot = E.remove(usr,special = 2)
		//Pilot.forceMove(H)
	spawn(1)
		H.updatehealth()
		//qdel(E)


/mob/living/carbon/human/proc/eject_from_body()
	set category = "Abilities"
	set name = "Eject from shell"
	set desc = "Eject from your humanoid mechanical shell."

	var/obj/item/organ/internal/E = get_int_organ(/obj/item/organ/internal/brain/yinslug)
	if(E)
		var/mob/living/Pilot = E.remove(src)
		Pilot.forceMove(get_turf(src))
		playsound(src, 'sound/mecha/mechmove03.ogg', 40, 1, 1)
	else to_chat(src, "You are not actually a Yin! You'd die if you ejected your brain")







///////////////////////////////////////////////
//////////// Yin Slaves ///////////////////////
///////////////////////////////////////////////



/datum/species/yinslaved
	name = "Yin slave"
	name_plural = "Yin slaves"
	icobase = 'icons/mob/human_races/r_yinslaved.dmi'
	deform = 'icons/mob/human_races/r_yinslaved.dmi'
	path = /mob/living/carbon/human/yinslaved
	default_language = "Galactic Common"
	unarmed_type = /datum/unarmed_attack/claws
	flesh_color = "#1F181F"

	eyes = "blank_eyes"

	species_traits = list(NO_BREATHE, NO_SCAN, NO_BLOOD, NO_DNA, VIRUSIMMUNE)
	bodyflags = HAS_ICON_SKIN_TONE | HAS_TAIL | TAIL_WAGGING | HAS_HEAD_ACCESSORY
	tox_mod = 0
	can_revive_by_healing = 1
	dietflags = DIET_OMNI
	reagent_tag = PROCESS_SYN

	icon_skin_tones = list(
		1 = "Human",
		2 = "Diona",
		3 = "Drask",
		4 = "Grey",
		5 = "Kidan",
		6 = "Unathi",
		7 = "Tajaran",
		8 = "Vulpkanin",
		9 = "Vox"
		)

/datum/species/yinslaved/updatespeciescolor(var/mob/living/carbon/human/H, var/owner_sensitive = 1) //Lets slaves made from different species look different
	if(H.species.name == "Yin slave")
		var/new_icobase = 'icons/mob/human_races/yinslaved/r_yinslaved.dmi'
		var/new_deform = 'icons/mob/human_races/yinslaved/r_yinslaved.dmi'
		switch(H.s_tone)
			if(9)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yinvox.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yinvox.dmi'
				tail = "voxtail_gry"
				name = "Vox"
			if(8)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yinvulpkanin.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yinvulpkanin.dmi'
				tail = "vulptail"
				name = "Vulpkanin"
			if(7)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yintajaran.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yintajaran.dmi'
				tail = "tajtail"
				name = "Tajaran"
			if(6)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yinlizard.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yinlizard.dmi'
				tail = "sogtail"
				name = "Unathi"
			if(5)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yinkidan.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yinkidan.dmi'
				tail = "blank"
				name = "Kidan"
			if(4)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yingrey.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yingrey.dmi'
				tail = "blank"
				name = "Grey"
			if(3)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yindrask.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yindrask.dmi'
				tail = "blank"
				name = "Drask"
			if(2)
				new_icobase = 'icons/mob/human_races/yinslaved/r_yindiona.dmi'
				new_deform = 'icons/mob/human_races/yinslaved/r_yindiona.dmi'
				tail = "blank"
				name = "Diona"
			else
				tail = "blank"
				name = "Human"

		H.change_icobase(new_icobase, new_deform, owner_sensitive)
		H.update_dna()