// Yin limbs.
/datum/robolimb/yin
	company = "Yin"
	desc = "Part of a Yin humanoid shell, made of sleek polymers and pneumatic cable."
	icon = 'icons/mob/human_races/r_pilot.dmi'
	unavailable_at_chargen = 1

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
	icon = 'icons/obj/grenade.dmi'
	icon_state = "rocket_fire"
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
	name = "brain"
	organ_tag = "brain"
	parent_organ = "head"
	icon = 'icons/mob/mob.dmi'
	icon_state = "headcrab"
	vital = 1
	max_damage = 200
	slot = "brain"
	status = ORGAN_ROBOT

/obj/item/organ/internal/brain/yinslug/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/item/organ/internal/brain/yinslug/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

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
