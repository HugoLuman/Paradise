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

/obj/item/organ/internal/brain/yinslug/process()
	if(isturf(loc) && !owner)
		for(var/mob/M in contents)
			M.forceMove(get_turf(src))
			M.reset_view()
		qdel(src)

/obj/item/organ/internal/brain/yinslug/remove(var/mob/living/user,special = 0)
	spawn(1)
		if(!special)
			var/mob/living/simple_animal/yin/Pilot = new /mob/living/simple_animal/yin(loc)
			if(owner.mind)
				Pilot.cached_dna = src.dna.Clone()
				Pilot.real_name = "[Pilot.cached_dna.real_name]"
				Pilot.name = "[Pilot.real_name]"
				Pilot.adjustBruteLoss(0.5*src.damage)
				owner.mind.transfer_to(Pilot)
				Pilot.loc = get_turf(src)
		..()
		qdel(src)

/obj/item/organ/internal/brain/yinslug/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	for(var/mob/M in src.contents)
		M.attackby(W,user, params)

/obj/item/organ/internal/brain/yinslug/proc/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

/obj/item/organ/internal/brain/yinslug/emp_act(var/intensity)
	for(var/mob/living/M in contents)
		M.emp_act(intensity)

/obj/item/organ/internal/brain/yinslug/ex_act(var/intensity)
	for(var/mob/living/M in contents)
		M.ex_act(intensity)

/obj/item/organ/internal/brain/yinslug/insert()
	..()
	for(var/mob/living/YI in contents)
		YI.mind.transfer_to(owner)
		owner.adjustBrainLoss((60 - YI.health)*2)
		qdel(YI)

/obj/item/organ/internal/brain/yinslug/container_resist(var/mob/living/L)
	var/mob/M = src.loc                      //Get our mob holder (if any).

	if(istype(M))
		M.unEquip(src)
		to_chat(M, "[src] wriggles out of your grip!")
		to_chat(src, "You wriggle out of [M]'s grip!")
	else if(istype(src.loc,/obj/item))
		to_chat(src, "You struggle free of [src.loc].")
		src.forceMove(get_turf(src))

	if(istype(M))
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/weapon/holder))
				return
		M.status_flags &= ~PASSEMOTES

	return