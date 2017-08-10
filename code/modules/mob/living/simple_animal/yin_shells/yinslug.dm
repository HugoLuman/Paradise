/*
  All the mobs related to the Yin go in here
*/

//Mob defines.
/mob/living/simple_animal/yin
	name = "yin"
	desc = "A small, intelligent creature mostly made of nerve tissue."
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "yin"
	icon_living = "yin"
	icon_dead = "yin_dead"
	icon_resting = "yin_asleep"
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	can_hide = 1
	ventcrawler = 2
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 5, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

	maxHealth = 60
	health = 60

	voice_name = "yin"
	speak_emote = list("buzzes")
	emote_hear = list("buzzes")
	emote_see = list("buzzes")

	response_help  = "pets"
	response_disarm = "pushes"
	response_harm   = "kicks"

	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	speed = 0
	stop_automated_movement = 1
	turns_per_move = 4

	var/datum/dna/cached_dna
	var/obj/item/organ/internal/brain/yinslug/mybrain
	holder_type = /obj/item/weapon/holder/yin
	can_collar = 0

/mob/living/simple_animal/yin/New(special = 2)
	..()
	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	if(special == 2)
		var/obj/item/organ/internal/brain/yinslug/Brainer = new /obj/item/organ/internal/brain/yinslug(src)
		Brainer.mypilot = src
		Brainer.loc = src
		mybrain = Brainer

	add_language("Galactic Common")
	add_language("Yin Tactical Uplink")

/mob/living/simple_animal/yin/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == INTENT_HELP)
		get_scooped(M)
	..()

/mob/living/simple_animal/yin/put_in_hands(obj/item/W)
	W.loc = get_turf(src)
	W.layer = initial(W.layer)
	W.dropped()

/mob/living/simple_animal/yin/put_in_active_hand(obj/item/W)
	to_chat(src, "<span class='warning'>You don't have any hands!</span>")
	return

/mob/living/simple_animal/yin/emote(var/act, var/m_type=1, var/message = null)
	if(stat)
		return

	var/on_CD = 0
	switch(act)
		if("chirp")
			on_CD = handle_emote_CD()
		else
			on_CD = 0

	if(on_CD == 1)
		return

	switch(act) //IMPORTANT: Emotes MUST NOT CONFLICT anywhere along the chain.
		if("chirp")
			message = "<B>\The [src]</B> chirps!"
			m_type = 2 //audible
			playsound(src, 'sound/misc/nymphchirp.ogg', 40, 1, 1)

	..(act, m_type, message)

/mob/living/simple_animal/yin/resist() // To enable escape from dead shells, without automatically kicking them out
	..()
	if(istype(loc,/mob/living/simple_animal/yin_shell))
		var/mob/living/simple_animal/yin_shell/MS = loc
		to_chat(src, "You wriggle out of the [loc] shell.")
		MS.pilot = null
		MS.name = MS.real_name
		forceMove(get_turf(MS))
	else if(istype(loc,/mob/living/carbon/human) || istype(loc,/obj/item/organ/external/head))
		var/mob/living/carbon/human/MH = loc
		to_chat(src, "You wriggle out of the [loc] shell.")
		forceMove(get_turf(MH))

/mob/living/simple_animal/yin/verb/enter_shell()
	set category = "Animal"
	set name = "Enter shell"
	set desc = "Enter the control pod of a humanoid mechanical shell."

	if(stat)
		to_chat(src, "You cannot climb into a shell in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		var/obj/item/organ/external/head/head = H.get_organ("head")
		//var/obj/item/organ/internal/brain/yinslug/P = H.get_organ("pilot")
		//var/species = H.get_species()
		if (!head)
			continue
/*		if(H.stat == DEAD && src.Adjacent(H) && species == "Yin")
			choices += H */
		if(H.stat == DEAD && src.Adjacent(H) && istype(head, /obj/item/organ/external/head/yin))
			choices += H
	for(var/mob/living/simple_animal/yin_shell/S in view(1,src))
		if(!S.pilot)
			choices += S

	var/mob/living/M = input(src,"Which shell do you wish to enter?") in null|choices

	if(!M || !src)
		return

	if(!(src.Adjacent(M)))
		return

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/MH = M
		if(MH.getBrainLoss()<200)
			to_chat(src, "This shell already has someone inside!")
			return
		to_chat(src, "You begin climbing into the empty control pod in [MH]'s head...")

	if(istype(M,/mob/living/simple_animal/yin_shell))
		var/mob/living/simple_animal/yin_shell/MS = M
		if(MS.pilot)
			to_chat(src, "This shell already has someone inside!")
			return
		to_chat(src, "You begin climbing into the empty control pod of the [MS]...")

	if(!do_after(src,20, target = M))
		to_chat(src, "As [M] moves away, you are dislodged and fall to the ground.")
		return

	if(!M || !src)
		return

	if(src.stat)
		to_chat(src, "You cannot climb into a shell in your current state.")
		return

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/MH = M
		if(MH.stat != DEAD)
			to_chat(src, "That is not an appropriate target.")
			return

	if(M in view(1, src))
		to_chat(src, "You enter the control pod of the [M] shell")
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/MH = M
			var/obj/item/organ/internal/brain/Y = mybrain
			//Y.set_dna(cached_dna)
			MH.internal_organs |= Y
			Y.insert(MH)
			mind.transfer_to(MH)
			Y.damage = ((60 - src.health)*2)
			//MH.adjustBrainLoss((60 - src.health)*2)
			forceMove(Y)
		else if(istype(M,/mob/living/simple_animal/yin_shell))
			var/mob/living/simple_animal/yin_shell/MS = M
			loc = MS
			if(MS.stat != DEAD)
				MS.pilot = src
				mind.transfer_to(MS)
				MS.name = "[MS.name] [real_name]"
				MS.resting = FALSE
				MS.stat = CONSCIOUS
				flick("[MS.icon_rise]", MS)
				MS.icon_state = "[MS.icon_living]"
		return
	else
		to_chat(src, "They are no longer in range!")
		return
/*
/mob/living/simple_animal/yinslug/proc/perform_entrance(var/mob/living/silicon/M)
	src.host = M
	src.forceMove(M)

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/head = H.get_organ("head")
		head.implants += src

	host.status_flags |= PASSEMOTES */