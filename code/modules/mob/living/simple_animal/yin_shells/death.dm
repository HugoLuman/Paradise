/mob/living/simple_animal/yin_shell/death(gibbed)
	health = 0
	icon_state = icon_dead
	stat = DEAD
	if(pilot)
		to_chat(src, "<span class=warning><b>Your mechanical shell has failed!</b> Use ''resist'' to leave it, or stay inside if you choose.</span>")
		mind.transfer_to(pilot)
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
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	playsound(src.loc, 'sound/goonstation/effects/robogib.ogg', 50, 1)

	flick("gibbed-r", animation)
	robogibs(loc, viruses)

	living_mob_list -= src
	dead_mob_list -= src
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)