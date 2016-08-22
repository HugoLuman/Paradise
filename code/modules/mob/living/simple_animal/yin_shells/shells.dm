/mob/living/simple_animal/yin_shell
	name = "Yin Shell"
	icon = 'icons/mob/yin_pilot.dmi'
	icon_state = "invader"
	icon_living = "invader"
	icon_resting = "invader_rest"
	icon_dead = "invader_dead"
	var/icon_die = "invader_die"	//Non-gib death animation
	icon_gib = "invader_gib"
	var/icon_rise = "invader_rise"	//Animation when exiting rest state
	var/icon_lie = "invader_lie"	//Animation when entering rest state
	var/icon_shield = "inv_shield"
	var/shield = 100
	var/maxShield = 100
	var/chargerate = 1			//Rate of shield recharge
	var/nocharge = 0 			//Prevents the shield charging when enabled
	var/deflector = null
	health = 200
	maxHealth = 200
	density = 1
	speed = 0
	a_intent = I_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	has_limbs = 0
	mob_size = MOB_SIZE_LARGE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	faction = list("yin")
	flying = 1
	universal_speak = 1
	resting = TRUE
	var/mob/living/pilot = null
	var/datum/effect/system/ion_trail_follow/ion_trail

/mob/living/simple_animal/yin_shell/New()
	..()
	icon_state = icon_resting
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/yin_shell/update_icons()				//This and the update_icon proc could probably be pared down,
	overlays.Cut()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(stat == UNCONSCIOUS || lying || resting)
		icon_state = icon_resting
	else
		icon_state = icon_living

/mob/living/simple_animal/yin_shell/handle_resting_state_icons() //but IDK how to do that and still have it animate nice and smooth
	if(icon_resting)
		if(resting && stat != DEAD)
			if(icon_state == icon_living)
				flick("[icon_lie]", src)
			icon_state = "icon_resting"
		else if(!stat)
			if(icon_state == icon_resting)
				flick("[icon_rise]", overlays)
			icon_state = "icon_living"

/mob/living/simple_animal/yin_shell/verb/eject_from_shell()
	set category = "Abilities"
	set name = "Eject from shell"
	set desc = "Eject from your mechanical shell."
	if(pilot)
		resting = TRUE
		stat = UNCONSCIOUS
		name = real_name
		lay_down()
		mind.transfer_to(pilot)
		pilot.loc = get_turf(src)
		pilot = null
		playsound(src, 'sound/mecha/mechmove03.ogg', 40, 1, 1)
		flick("[icon_lie]", src)
		icon_state = "icon_resting"
		handle_resting_state_icons()

/mob/living/simple_animal/yin_shell/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		adjustHealth(Proj.damage)
		if(shield > 0)
			src.visible_message("<span class='danger'>[src]'s shields absorb the [Proj]!</span>")
		else
			Proj.on_hit(src, 0)
	return 0

/mob/living/simple_animal/yin_shell/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(attempt_harvest(O, user))
		return
	user.do_attack_animation(src)
	if(istype(O) && istype(user) && !O.attack(src, user))
		var/damage = 0
		if(O.force)
			if(O.force >= force_threshold)
				damage = O.force
				if(O.damtype == STAMINA)
					damage = 0
				visible_message("<span class='danger'>[user] has [O.attack_verb.len ? "[pick(O.attack_verb)]": "attacked"] [src] with [O]!</span>",\
								"<span class='userdanger'>[user] has [O.attack_verb.len ? "[pick(O.attack_verb)]": "attacked"] you with [O]!</span>")
			else if(shield > 0)
				visible_message("<span class='danger'>[src]'s shield deflects the [O]!</span>",\
								"<span class='userdanger'>Your shield deflects the [O]!.</span>")
			else
				visible_message("<span class='danger'>[O] bounces harmlessly off of [src].</span>",\
								"<span class='userdanger'>[O] bounces harmlessly off of [src].</span>")
		else
			user.visible_message("<span class='warning'>[user] gently taps [src] with [O].</span>",\
								"<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		adjustHealth(damage)

/mob/living/simple_animal/yin_shell/adjustHealth(amount)
	if(status_flags & GODMODE)
		return 0
	if(shield > 0 && amount > 0)
		shield = Clamp(shield - amount, 0, maxShield)
		//flick("[icon_shield]", deflector)
		if((amount-shield) > 0)
			overlays += "[icon_shield]_break"
			//src.visible_message("<span class='danger'>[src]'s shields fizzle out!</span>")
			spawn(3)
				overlays -= "[icon_shield]_break"
			if(!nocharge)
				var/datum/effect/system/spark_spread/s = new
				s.set_up(2, 1, src)
				s.start()
				playsound(src.loc, 'sound/weapons/IonRifle.ogg', 50, 1)
				shield = 0
				nocharge = 1
				spawn(100)
					if(stat != DEAD)
						nocharge = 0
						shield = (maxShield * 0.2)
						playsound(src.loc, 'sound/effects/YinShieldCharge.ogg', 50, 1)
						overlays += icon_shield
						spawn(10)
							overlays -= icon_shield
		else overlays += icon_shield
		playsound(src.loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
		//src.visible_message("<span class='danger'>[src]'s shields absorb the impact!</span>")
		spawn(4)
			overlays -= icon_shield
	else bruteloss = Clamp(bruteloss + amount, 0, maxHealth)
	handle_regular_status_updates()

/mob/living/simple_animal/yin_shell/Stat()
	..()
	if(statpanel("Status"))
		stat("Shield:", "[shield]/[maxShield]")

/mob/living/simple_animal/yin_shell/Process_Spacemove(var/check_drift = 0)
	return 1


////////////////////////////////////////////////////
////////	Individual shell definitions	////////
////////////////////////////////////////////////////










/*/mob/living/simple_animal/yin_shell/adjustHealth(amount)
	if(status_flags & GODMODE)
		return 0
	if(shield > 0 && amount > 0)
		shield = Clamp(shield - amount, 0, maxShield)
		//flick("[icon_shield]", deflector)
		if((amount-shield) > 0)
			overlays += "[icon_shield]_break"
			//src.visible_message("<span class='danger'>[src]'s shields fizzle out!</span>")
			spawn(3)
				overlays -= "[icon_shield]_break"
			if(!nocharge)
				var/datum/effect/system/spark_spread/s = new
				s.set_up(2, 1, src)
				s.start()
				playsound(src.loc, 'sound/weapons/IonRifle.ogg', 50, 1)
				shield = 0
				nocharge = 1
				spawn(100)
					if(stat != DEAD)
						nocharge = 0
						shield = (maxShield * 0.2)
						playsound(src.loc, 'sound/effects/YinShieldCharge.ogg', 50, 1)
						overlays += icon_shield
						spawn(10)
							overlays -= icon_shield
		else overlays += icon_shield
		playsound(src.loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
		//src.visible_message("<span class='danger'>[src]'s shields absorb the impact!</span>")
		spawn(4)
			overlays -= icon_shield
	else bruteloss = Clamp(bruteloss + amount, 0, maxHealth)
	handle_regular_status_updates()
	*/