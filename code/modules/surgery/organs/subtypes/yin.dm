// Yin limbs.
/datum/robolimb/yin
	company = "Yin"
	desc = "Part of a Yin humanoid shell, made of sleek polymers and pneumatic cable."
	icon = 'icons/mob/human_races/r_pilot.dmi'
	//unavailable_at_chargen = 1
	has_subtypes = 1

/datum/robolimb/yin/plasma
	company = "Yin plasma"
	desc = "Part of a Yin humanoid shell, made of pneumatic cable with a decorative plasma coating."
	icon = 'icons/mob/human_races/cyberlimbs/yin/plasma.dmi'
	has_subtypes = null

/datum/robolimb/yin/gold
	company = "Yin gold"
	desc = "Part of a Yin humanoid shell, made of pneumatic cable with a decorative gold plating."
	icon = 'icons/mob/human_races/cyberlimbs/yin/gold.dmi'
	has_subtypes = null

/datum/robolimb/yin/diamond
	company = "Yin diamond"
	desc = "Part of a Yin humanoid shell, made of pneumatic cable with decorative diamond plating."
	icon = 'icons/mob/human_races/cyberlimbs/yin/diamond.dmi'
	has_subtypes = null

/obj/item/organ/external/head/yin
	can_intake_reagents = 0
	vital = 0
	max_damage = 50 //made same as arm, since it is not vital
	min_broken_damage = 30
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/head/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/chest/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/chest/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/groin/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/groin/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/arm/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/arm/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/arm/right/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/arm/right/yin/New()
	robotize("Yin")
	..()
/obj/item/organ/external/leg/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/leg/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/leg/right/yin
	encased = null
	status = ORGAN_ROBOT


/obj/item/organ/external/leg/right/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/foot/yin
	encased = null
	status = ORGAN_ROBOT


/obj/item/organ/external/foot/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/foot/right/yin
	encased = null
	status = ORGAN_ROBOT


/obj/item/organ/external/foot/right/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/hand/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/hand/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/external/hand/right/yin
	encased = null
	status = ORGAN_ROBOT

/obj/item/organ/external/hand/right/yin/New()
	robotize("Yin")
	..()

/obj/item/organ/internal/reactor
	name = "mini reactor"
	desc = "A compact nuclear reactor designed to fit inside and power a synthetic body"
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "reactor"
	organ_tag = "heart"
	parent_organ = "chest"
	slot = "heart"
	vital = 1
	status = ORGAN_ROBOT

/obj/item/organ/internal/reactor/New()
	robotize()
	..()

/obj/item/organ/internal/reactor/insert()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = CONSCIOUS
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")


///////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The "brain," aka the little critter that pilots this thing                 ////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////


/obj/item/organ/internal/brain/yinslug
	name = "pilot"
	desc = "A small, intelligent creature mostly made of nerve tissue. Maybe it needs help finding its vessel?"
	organ_tag = "brain"
	parent_organ = "head"
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "yin_icon"
	vital = 1
	max_damage = 200
	slot = "brain"

/obj/item/organ/internal/brain/yinslug/New()
	..()
	processing_objects.Add(src)

/obj/item/organ/internal/brain/yinslug/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/item/organ/internal/brain/yinslug/insert()
	..()
	owner.stat = CONSCIOUS

/obj/item/organ/internal/brain/yinslug/remove(var/mob/living/user,special = 3)
	var/mob/living/simple_animal/yin/Pilot = new /mob/living/simple_animal/yin(src)
	Pilot.loc = get_turf(owner)
	. = Pilot
	if(special == 3)
		if(owner.mind)
			Pilot.loc = get_turf(src)
			Pilot.cached_dna = src.dna.Clone()
			Pilot.real_name = "[Pilot.cached_dna.real_name]"
			Pilot.name = "[Pilot.real_name]"
			Pilot.adjustBruteLoss(0.5*src.damage)
			owner.mind.transfer_to(Pilot)
	if(special == 2) // For when the humanoid shell dies and the worm is left sitting in the body
		if(owner.mind)
			Pilot.cached_dna = src.dna.Clone()
			Pilot.real_name = "[Pilot.cached_dna.real_name]"
			Pilot.name = "[Pilot.real_name]"
			Pilot.adjustBruteLoss(0.5*src.damage)
			Pilot.loc = owner
			owner.mind.transfer_to(Pilot)
	spawn(1)
		..()
		qdel(src)


/obj/item/weapon/holder/yin
	name = "Yin"
	desc = "A small, intelligent creature mostly made of nerve tissue."
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "yin_icon"

/obj/item/weapon/holder/yin/attempt_become_organ(obj/item/organ/external/parent, mob/living/carbon/human/H)
	if(!parent)
		log_debug("Attempting to insert into a null parent!")
		return 0
	if(H.get_int_organ(/obj/item/organ/internal/brain))
		// one brain at a time
		return 0
	var/obj/item/organ/internal/brain/yinslug/holder = new()
	holder.parent_organ = parent.limb_name
	forceMove(holder)
	holder.insert(H)
	to_chat(world, "attempt_become_organ fired")
	for(var/mob/living/simple_animal/yin/YI in contents)
		YI.mind.transfer_to(H)
		holder.set_dna(YI.cached_dna)
		H.adjustBrainLoss((60 - YI.health)*2)
		qdel(YI)
	return 1

/obj/item/weapon/holder/yin/proc/insert()
	attempt_become_organ()