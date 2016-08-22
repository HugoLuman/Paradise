
////HUD NONSENSE////
/obj/screen/yin_pilot
	icon = 'icons/mob/yin_pilot.dmi'

/obj/screen/yin_pilot/hide
	icon_state = "ui_hide"
	name = "Hide"
	desc = "Hide beneath cover, such as tables, desks, or loose items."

/obj/screen/yin_pilot/hide/Click()
	if(istype((usr), /mob/living/simple_animal/yin))
		var/mob/living/simple_animal/yin/Y = usr
		Y.hide()

/obj/screen/yin_pilot/enter_shell
	icon_state = "ui_entershell"
	name = "Enter Shell"
	desc = "Enter an empty mechanical shell and take control."

/obj/screen/yin_pilot/enter_shell/Click()
	if(istype((usr), /mob/living/simple_animal/yin))
		var/mob/living/simple_animal/yin/Y = usr
		Y.enter_shell()

/obj/screen/yin_pilot/exit_shell
	icon_state = "ui_resist"
	name = "Escape Shell/Resist"
	desc = "Use this to leave an inactive shell."

/obj/screen/yin_pilot/exit_shell/Click()
	if(istype((usr), /mob/living/simple_animal/yin))
		var/mob/living/simple_animal/yin/Y = usr
		Y.resist()

/mob/living/simple_animal/yin/create_mob_hud()
	if(client && !hud_used)
		hud_used = new /datum/hud/yin_pilot(src)

/datum/hud/yin_pilot/New(mob/owner)
	..()
	var/obj/screen/using

	using = new /obj/screen/yin_pilot/hide()
	using.screen_loc = ui_rhand
	static_inventory += using

	using = new /obj/screen/yin_pilot/enter_shell()
	using.screen_loc = ui_lhand
	static_inventory += using

	using = new /obj/screen/yin_pilot/exit_shell()
	using.screen_loc = ui_zonesel
	static_inventory += using

	mymob.healths = new /obj/screen/healths()
	infodisplay += mymob.healths