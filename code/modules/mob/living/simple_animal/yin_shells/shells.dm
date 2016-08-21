/mob/living/simple_animal/yin_shell
	name = "Yin Shell"
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "invader"
	icon_living = "invader"
	icon_resting = "invader_rest"
	icon_dead = "invader_dead"
	health = 200
	maxHealth = 200
	density = 1
	speed = 0
	a_intent = I_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	faction = list("yin")
	flying = 1
	universal_speak = 1
	resting = 1
	var/mob/living/pilot = null

/mob/living/simple_animal/yin_shell/verb/eject_from_shell()
	set category = "Abilities"
	set name = "Eject from shell"
	set desc = "Eject from your mechanical shell."
	if(pilot)
		stat = UNCONSCIOUS
		name = real_name
		mind.transfer_to(pilot)
		pilot.loc = get_turf(src)


////////////////////////////////////////////////////
////////	Individual shell definitions	////////
////////////////////////////////////////////////////