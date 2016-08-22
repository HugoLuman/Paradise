/mob/living/simple_animal/yin_shell/death(gibbed)
	health = 0
	flick ("[icon_die]", src)
	icon_state = icon_dead
	playsound(src.loc, 'sound/goonstation/effects/robogib.ogg', 70, 1)
	stat = DEAD
	name = "[initial(name)] wreck"
	if(pilot)
		to_chat(src, "<span class=warning><b>Your mechanical shell has failed!</b> Use ''resist'' to leave it, or stay inside if you choose.</span>")
		mind.transfer_to(pilot)
		pilot = null
	return ..(gibbed)

/mob/living/simple_animal/yin_shell/gib()
	if(pilot)
		mind.transfer_to(pilot)
		pilot.loc = get_turf(src)
	var/atom/movable/overlay/animation = null
	notransform = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/yin_pilot.dmi'
	animation.master = src

	playsound(src.loc, 'sound/effects/YinBlowUp.ogg', 100, 1)

	flick("[src.icon_gib]", animation)
	spawn(3)
		playsound(src.loc, 'sound/effects/Explosion2.ogg', 100, 1)
	spawn(4)
		robogibs(loc, viruses)

	living_mob_list -= src
	dead_mob_list -= src
	spawn(10)
		if(animation)	qdel(animation)
		if(src)			qdel(src)
		if(ion_trail)	qdel(ion_trail)