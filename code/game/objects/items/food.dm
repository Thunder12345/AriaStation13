/*
CONTAINS:
DONUT BOX
EGG BOX
MONKEY CUBE BOX

*/


/mob/living/carbon/var/last_eating = 0

/obj/item/kitchen/donut_box
	var/amount = 6
	icon = 'food.dmi'
	icon_state = "donutbox"
	name = "donut box"
/obj/item/kitchen/egg_box
	var/amount = 12
	icon = 'food.dmi'
	icon_state = "eggbox"
	name = "egg box"

/obj/item/kitchen/donut_box/proc/update()
	src.icon_state = text("donutbox[]", src.amount)
	return

/*
/obj/item/kitchen/donut_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/donut) && (amount < 6))
		user.drop_item()
		W.loc = src
		usr << "You place a donut back into the box."
	src.update()
	return
*/

/obj/item/kitchen/donut_box/MouseDrop(mob/user as mob)
	if ((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(user, /mob/living/carbon/metroid))
			if (usr.hand)
				if (!( usr.l_hand ))
					spawn( 0 )
						src.attack_hand(usr, 1, 1)
						return
			else
				if (!( usr.r_hand ))
					spawn( 0 )
						src.attack_hand(usr, 0, 1)
						return
	return

/obj/item/kitchen/donut_box/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/kitchen/donut_box/attack_hand(mob/user as mob, unused, flag)
	if (flag)
		return ..()
	src.add_fingerprint(user)
	if (locate(/obj/item/weapon/reagent_containers/food/snacks/donut, src))
		for(var/obj/item/weapon/reagent_containers/food/snacks/donut/P in src)
			if (!usr.l_hand)
				P.loc = usr
				P.layer = 20
				usr.l_hand = P
				usr.update_clothing()
				usr << "You take a donut out of the box."
				break
			else if (!usr.r_hand)
				P.loc = usr
				P.layer = 20
				usr.r_hand = P
				usr.update_clothing()
				usr << "You take a donut out of the box."
				break
	else
		if (src.amount >= 1)
			src.amount--
			var/obj/item/weapon/reagent_containers/food/snacks/donut/D = new /obj/item/weapon/reagent_containers/food/snacks/donut
			D.loc = usr.loc
			if(ishuman(usr))
				if(!usr.get_active_hand())
					usr.put_in_hand(D)
					usr << "You take a donut out of the box."
			else
				D.loc = get_turf(src)
				usr << "You take a donut out of the box."

	src.update()
	return

/obj/item/kitchen/donut_box/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/P in src)
		n++
	if (n <= 0)
		n = 0
		usr << "There are no donuts left in the box."
	else
		if (n == 1)
			usr << "There is one donut left in the box."
		else
			usr << text("There are [] donuts in the box.", n)
	return

/obj/item/kitchen/egg_box/proc/update()
	src.icon_state = text("eggbox[]", src.amount)
	return


/obj/item/kitchen/egg_box/MouseDrop(mob/user as mob)
	if ((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if (usr.hand)
			if (!( usr.l_hand ))
				spawn( 0 )
					src.attack_hand(usr, 1, 1)
					return
		else
			if (!( usr.r_hand ))
				spawn( 0 )
					src.attack_hand(usr, 0, 1)
					return
	return

/obj/item/kitchen/egg_box/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/kitchen/egg_box/attack_hand(mob/user as mob, unused, flag)
	if (flag)
		return ..()
	src.add_fingerprint(user)
	if (locate(/obj/item/weapon/reagent_containers/food/snacks/egg, src))
		for(var/obj/item/weapon/reagent_containers/food/snacks/egg/P in src)
			if (!usr.l_hand)
				P.loc = usr.loc
				P.layer = 20
				usr.l_hand = P
				P = null
				usr.update_clothing()
				usr << "You take an egg out of the box."
				break
			else if (!usr.r_hand)
				P.loc = usr.loc
				P.layer = 20
				usr.r_hand = P
				P = null
				usr.update_clothing()
				usr << "You take an egg out of the box."
				break
	else
		if (src.amount >= 1)
			src.amount--
			new /obj/item/weapon/reagent_containers/food/snacks/egg( src.loc )
			usr << "You take an egg out of the box."
	src.update()
	return

/obj/item/kitchen/egg_box/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/weapon/reagent_containers/food/snacks/egg/P in src)
		n++
	if (n <= 0)
		n = 0
		usr << "There are no eggs left in the box."
	else
		if (n == 1)
			usr << "There is one egg left in the box."
		else
			usr << text("There are [] eggs in the box.", n)
	return

/obj/item/weapon/monkeycube_box
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'food.dmi'
	icon_state = "monkeycubebox"
	var/amount = 4

	attack_hand(mob/user as mob, unused, flag)
		add_fingerprint(user)

		if(user.r_hand == src || user.l_hand == src)
			if(amount)
				var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/M = new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
				if (user.hand)
					user.l_hand = M
				else
					user.r_hand = M
				M.loc = user
				M.layer = 20
				user.update_clothing()
				user << "You take a monkey cube out of the box."
				amount--
			else
				user << "There are no monkey cubes left in the box."
		else
			..()

		return

	attack_paw(mob/user as mob)
		return attack_hand(user)

/obj/item/weapon/pizza_box
	name = "pizza box"
	desc = "Delivery! Tip me please!"
	icon = 'pizzabox.dmi'
	icon_state = "0"
	var/open = 1
	var/dirtystate = "0"
	var/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/content = null

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		..()
		if (istype(O, /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza))
			if (open)
				if(!content)
					usr.drop_item()
					content = O;
					O.loc = src
					user << "\blue You put [O] into the pizza box."
					icon_state = "closed"
					open = 0
				else
					user << "\red The pizza box already contains pizza."
			else
				user << "\red The pizza box is closed."


	attack_hand(mob/user as mob, unused, flag)
		add_fingerprint(user)

		if(user.r_hand == src || user.l_hand == src)
			var/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/M = content

			if(open)
				if(M)
					if (user.hand)
						user.l_hand = M
					else
						user.r_hand = M
					M.loc = user
					M.layer = 20
					user.update_clothing()
					user << "You take \the [M] out of the box."
					dirtystate = "[icon_state]-0"
					icon_state = dirtystate
					content = null
				else
					user << "You close the pizza box."
					icon_state = "closed"
					open = 0
			else
				if(M)
					user << "You open the pizza box. It contains [M]!"
					icon_state = "[M.icon_state]"
				else
					user << "You open the pizza box."
					icon_state = dirtystate
				open = 1
		else
			..()

		return

	attack_paw(mob/user as mob)
		return attack_hand(user)