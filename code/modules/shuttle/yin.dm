/obj/docking_port/mobile/yin
	name = "yin ship"
	id = "yin_ship"
	dwidth = 16
	dheight = 8
	width = 17
	height = 17

/obj/machinery/computer/shuttle/yin
	name = "Yin shuttle terminal"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "yin_ship"
	possible_destinations = "yin_nw;yin_ne;yin_sw;yin_se"

/obj/structure/disposaloutlet/yin
	name = "ejection port"
	desc = "A mysterious dialating door."
	icon = 'icons/obj/yin.dmi'
	icon_state = "outlet"

/obj/structure/disposaloutlet/yin/ex_act()
	return

/obj/machinery/disposal/deliveryChute/yin
	name = "transit chute"
	desc = "For leaving the ship"
	density = 1
	icon = 'icons/obj/yin.dmi'
	icon_state = "intake"

/obj/machinery/disposal/deliveryChute/yin/ex_act()
	return

/obj/structure/yinpipe/white
	name = "tube"
	desc = "A big, white, polymer tube."
	icon = 'icons/obj/yin.dmi'
	icon_state = "wpipe"
	density = 0
	anchored = 1

/obj/structure/yinpipe/ex_act()
	return

/obj/machinery/gun_turret/yin
	name = "plasma turret"
	desc = "An eye-shaped device that fires beams of plasma."
	density = 1
	anchored = 1
	faction = "yin"
	bullet_type = /obj/item/projectile/plasma/yin
	firing_sound = 'sound/weapons/emitter2.ogg'
	icon = 'icons/obj/yin.dmi'
	icon_state = "eyeturret0"
	base_icon = "eyeturret"

/obj/item/projectile/plasma/yin
	name = "plasma blast"
	icon_state = "plasmacutter"
	damage_type = BRUTE
	damage = 40
	irradiate = 20
	range = 15

/turf/simulated/shuttle/floor/yin
	name = "floor"
	icon = 'icons/obj/yin.dmi'
	icon_state = "floor1"

/obj/structure/yinpipe/red
	name = "pipe"
	icon = 'icons/obj/yin.dmi'
	icon_state = "pipe1"
	density = 0
	anchored = 1
	light_range = 5
	light_power = 2

/obj/structure/yin_core
	name = "Control Core"
	icon = 'icons/obj/yin.dmi'
	icon_state = "yincore"
	density = 1
	anchored = 1
	light_range = 3
	light_power = 1

/obj/machinery/door/poddoor/yin_ver
	icon = 'icons/obj/yin.dmi'

/obj/item/clothing/mask/gas/voice/yin2
	name = "morphic mask"
	desc = "An more perfect disguise"
	icon_state = "hailer_white"
	flags_inv = HIDEFACE
	flags = MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | BLOCKHAIR | ABSTRACT
	var/mob/living/carbon/human/Guise
	species_disguise = "human"

/obj/item/clothing/mask/gas/voice/yin2/New()
	..()
	var/mob/living/carbon/human/dummy/Z = new /mob/living/carbon/human/dummy(src)
	Z.real_name = "???"
	Guise = Z

/obj/item/clothing/mask/gas/voice/yin2/equipped(mob/living/user, slot)
	..()
	if(slot == slot_wear_mask)
		src.appearance = Guise.appearance
		disguise(user)
		processing_objects.Add(src)
		species_disguise = Guise.get_species()

/obj/item/clothing/mask/gas/voice/yin2/process(var/mob/living/H)
	loc.remove_alt_appearance("generic_crew_disguise")
	disguise(loc)

/obj/item/clothing/mask/gas/voice/yin2/proc/disguise(mob/living/H)
	if(istype(H))
		var/image/I = image(icon = 'icons/mob/human.dmi' , icon_state = "blank", loc = H)
		I.override = 1
		I.overlays = Guise
		I.overlays += H.overlays
		I.overlays += Guise.overlays
		H.add_alt_appearance("generic_crew_disguise", I, mob_list)

/obj/item/clothing/mask/gas/voice/yin2/attack_self(mob/user)
	if(istype(user))
		Guise.change_appearance(APPEARANCE_ALL, usr, usr, check_species_whitelist = 1)

/obj/item/clothing/mask/gas/voice/yin2/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("generic_crew_disguise")
	src.appearance = initial(appearance)
	processing_objects.Remove(src)