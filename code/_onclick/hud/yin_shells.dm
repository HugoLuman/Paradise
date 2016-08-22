
////HUD NONSENSE////
/obj/screen/yin_shell
	icon = 'icons/mob/yin_pilot.dmi'

/obj/screen/yin_shell/exit_shell
	icon_state = "ui_resist"
	name = "Eject from Shell"
	desc = "Eject from your mechanical shell."

/obj/screen/yin_shell/exit_shell/Click()
	if(istype((usr), /mob/living/simple_animal/yin_shell))
		var/mob/living/simple_animal/yin_shell/Y = usr
		Y.eject_from_shell()

/obj/screen/yin_shell/shield_display
	icon_state = "shield0"
	name = "Shield Strength"
	desc = "Current strength of deflector shields."


/mob/living/simple_animal/yin_shell/create_mob_hud()
	if(client && !hud_used)
		hud_used = new /datum/hud/yin_shell(src)

/datum/hud/yin_shell/New(mob/living/simple_animal/yin_shell/owner)
	..()
	var/obj/screen/using

	using = new /obj/screen/yin_shell/exit_shell()
	using.screen_loc = ui_construct_pull
	static_inventory += using

	mymob.healths = new /obj/screen/healths()
	mymob.healths.icon = 'icons/mob/yin_pilot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "shell integrity"
	mymob.healths.screen_loc = ui_health
	infodisplay += mymob.healths

	alien_plasma_display = new /obj/screen/yin_shell/shield_display()
	alien_plasma_display.screen_loc = ui_internal
	infodisplay += alien_plasma_display