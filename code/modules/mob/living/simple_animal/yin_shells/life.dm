/mob/living/simple_animal/yin_shell/Life()
	if(stat == DEAD)
		return

	..()

	if (src.notransform)
		return

	//Status updates, death etc.
	clamp_values()
	update_icons()

	if(!nocharge)
		if(shield < maxShield)
			shield += chargerate
		else shield = maxShield

	if(stat == UNCONSCIOUS)
		resting = TRUE
		lay_down()

	if(!pilot || !client)
		resting = TRUE
		stat = UNCONSCIOUS
		name = initial(name)

/mob/living/simple_animal/yin_shell/proc/clamp_values()
	SetStunned(min(stunned, 30))
	SetParalysis(min(paralysis, 30))
	SetWeakened(min(weakened, 20))
	sleeping = 0
	ear_deaf = 0

/mob/living/simple_animal/yin_shell/handle_regular_hud_updates()
	..()
	if(hud_used.alien_plasma_display && maxShield > 0)
		switch(shield / maxShield * 30)
			if(30 to INFINITY)		hud_used.alien_plasma_display.icon_state = "shield0"
			if(26 to 29)			hud_used.alien_plasma_display.icon_state = "shield1"
			if(21 to 25)			hud_used.alien_plasma_display.icon_state = "shield2"
			if(16 to 20)			hud_used.alien_plasma_display.icon_state = "shield3"
			if(11 to 15)			hud_used.alien_plasma_display.icon_state = "shield4"
			if(6 to 10)				hud_used.alien_plasma_display.icon_state = "shield5"
			if(1 to 5)				hud_used.alien_plasma_display.icon_state = "shield6"
			if(0)					hud_used.alien_plasma_display.icon_state = "shield7"