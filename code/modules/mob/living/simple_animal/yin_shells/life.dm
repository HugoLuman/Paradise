/mob/living/simple_animal/yin_shell/Life()
	if(stat == DEAD)
		return

	..()

	if (src.notransform)
		return

	//Status updates, death etc.
	clamp_values()

	if(stat == UNCONSCIOUS)
		resting = 1
		icon_state = icon_resting

	if(!pilot)
		resting = 1
		stat = UNCONSCIOUS
		name = initial(name)

/mob/living/simple_animal/yin_shell/proc/clamp_values()
	SetStunned(min(stunned, 30))
	SetParalysis(min(paralysis, 30))
	SetWeakened(min(weakened, 20))
	sleeping = 0
	ear_deaf = 0