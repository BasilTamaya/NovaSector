/obj/item/clothing/suit
	name = "suit"
	icon = 'icons/obj/clothing/suits/default.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	var/fire_resist = T0C+100
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/tank/jetpack/oxygen/captain,
		/obj/item/storage/belt/holster,
		/obj/item/cane, // NOVA EDIT ADDITION
		)
	armor_type = /datum/armor/none
	drop_sound = 'sound/items/handling/cloth/cloth_drop1.ogg'
	pickup_sound = 'sound/items/handling/cloth/cloth_pickup1.ogg'
	slot_flags = ITEM_SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	limb_integrity = 0 // disabled for most exo-suits

/obj/item/clothing/suit/worn_overlays(mutable_appearance/standing, isinhands = FALSE, file2use = null, mutant_styles = NONE) // NOVA EDIT CHANGE - TAURS AND TESHIS - ORIGINAL: /obj/item/clothing/suit/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")

	// NOVA EDIT ADDITION START - TAUR-FULLBODY SUITS
	if(mutant_styles & STYLE_TAUR_ALL)
		if (worn_icon_taur_snake)
			worn_x_offset = -16
		else if (worn_icon_taur_paw)
			worn_x_offset = -16
		else if (worn_icon_taur_hoof)
			worn_x_offset = -16
	else
		worn_x_offset = 0

	// NOVA EDIT ADDITION END
	var/mob/living/carbon/human/wearer = loc
	if(!ishuman(wearer) || !wearer.w_uniform)
		return
	var/obj/item/clothing/under/undershirt = wearer.w_uniform
	if(!istype(undershirt) || !LAZYLEN(undershirt.attached_accessories))
		return

	var/obj/item/clothing/accessory/displayed = undershirt.attached_accessories[1]
	if(displayed.above_suit)
		. += undershirt.modify_accessory_overlay() // NOVA EDIT CHANGE - ORIGINAL: . += undershirt.accessory_overlay

/obj/item/clothing/suit/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file, mutant_styles) // NOVA EDIT CHANGE - ORIGINAL: separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file)
	. = ..()
	if(isinhands)
		return
	if(GET_ATOM_BLOOD_DNA_LENGTH(src))
		var/bloodfile2use = (mutant_styles & STYLE_TAUR_ALL) ? 'modular_nova/master_files/icons/mob/64x32_blood.dmi' : 'icons/effects/blood.dmi' // NOVA EDIT ADDITION
		. += mutable_appearance(bloodfile2use, "[blood_overlay_type]blood") // NOVA_EDIT_CHANGE - ORIGINAL: . += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")

/obj/item/clothing/suit/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_oversuit()
