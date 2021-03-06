#define METEOR_TEMPERATURE

/var/const/meteor_wave_delay = 625 //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

/var/const/meteors_in_wave = 10 //THIS should be better, Spess.
/var/const/meteors_in_small_wave = 4

/proc/meteor_wave(var/number = meteors_in_wave)
	if(!ticker || wavesecret)
		return

	wavesecret = 1
	for(var/i = 0 to number)
		spawn(rand(10,100))
			spawn_meteor()
	spawn(meteor_wave_delay)
		wavesecret = 0

/proc/spawn_meteors(var/number = meteors_in_small_wave)
	for(var/i = 0; i < number; i++)
		spawn(0)
			spawn_meteor()

/proc/spawn_meteor()

	var/startx
	var/starty
	var/endx
	var/endy
	var/turf/pickedstart
	var/turf/pickedgoal
	var/max_i = 10//number of tries to spawn meteor.


	do
		switch(pick(1,2,3,4))
			if(1) //NORTH
				starty = world.maxy-15
				startx = rand(15, world.maxx-15)
				endy = 15
				endx = rand(15, world.maxx-15)
			if(2) //EAST
				starty = rand(15,world.maxy-15)
				startx = world.maxx-15
				endy = rand(15, world.maxy-15)
				endx = 15
			if(3) //SOUTH
				starty = 15
				startx = rand(15, world.maxx-15)
				endy = world.maxy-15
				endx = rand(15, world.maxx-15)
			if(4) //WEST
				starty = rand(15, world.maxy-15)
				startx = 15
				endy = rand(15,world.maxy-15)
				endx = world.maxx-15

		pickedstart = locate(startx, starty, 1)
		pickedgoal = locate(endx, endy, 1)
		max_i--
		if(max_i<=0) return

	while (!istype(pickedstart, /turf/space) || pickedstart.loc.name != "Space" ) //FUUUCK, should never happen.


	var/obj/effect/meteor/M
	switch(rand(1, 100))
		if(1 to 5)
			if(prob(80))
				M = new /obj/effect/meteor/huge( pickedstart )
			else
				M = new /obj/effect/meteor/huge/ice( pickedstart )
		if(6 to 15)
			if(prob(50))
				M = new /obj/effect/meteor/big( pickedstart )
			else
				M = new /obj/effect/meteor/big/uranium( pickedstart )
		if(16 to 75)
			M = new /obj/effect/meteor( pickedstart )
		if(76 to 100)
			M = new /obj/effect/meteor/small( pickedstart )

	M.dest = pickedgoal
	M.SpinAnimation(10,-1)
	spawn(0)
		walk_towards(M, M.dest, 1)

	return

/obj/effect/meteor
	name = "meteor"
	icon = 'meteor.dmi'
	icon_state = "large"
	density = 1
	anchored = 1.0
	var/hits = 1
	var/dest
	pass_flags = PASSTABLE
	var/genmaterials = list(/turf/simulated/mineral/random/high_chance)

	New()
		..()
		SpinAnimation(10,-1)

/obj/effect/meteor/small
	name = "small meteor"
	icon_state = "small"
	pass_flags = PASSTABLE | PASSGRILLE

/obj/effect/meteor/Move()
//	var/turf/T = src.loc
	//FUCK YOU. FUCK YOU ALL, METEORS. ~Hawk.
	/*if (istype(T, /turf))
		T.hotspot_expose(METEOR_TEMPERATURE, 1000) */
	..()
	return

/obj/effect/meteor/Bump(atom/A)
	spawn(0)
		for(var/mob/M in range(10, src))
			if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
				shake_camera(M, 3, 1)
		if (A)
			A.meteorhit(src)
			playsound(src.loc, 'meteorimpact.ogg', 40, 1)
		if (--src.hits <= 0)
			if(prob(15))// && !istype(A, /obj/structure/grille))
				explosion(src.loc, 4, 5, 6, 7, 0)
				playsound(src.loc, "explosion", 50, 1)
			else
				makematerials(1)
			del(src)
	return


/obj/effect/meteor/ex_act(severity)

	if (severity < 4)
		del(src)
	return

/obj/effect/meteor/proc/makematerials(range,severity=1)
	var/turf/epicenter = get_turf(src)
	var/list/aTurfs = circlerangeturfs(epicenter,range)

	for(var/turf/T in aTurfs)
		for(var/atom/A in T)
			A.ex_act(severity)
		T.ex_act(severity)

	epicenter = get_turf(src)
	aTurfs = circlerangeturfs(epicenter,range)

	for(var/turf/T in aTurfs)
		if(!T || T.density) continue

		var/mattertype = pick(genmaterials)
		if(!mattertype)	continue

		new mattertype(T)


/obj/effect/meteor/big
	name = "big meteor"
	icon_state = "flaming"
	hits = 0
	genmaterials = list(/turf/simulated/mineral/plasma)

	ex_act(severity)
		return

	Bump(atom/A)
		spawn(0)
			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
					shake_camera(M, 3, 1)
			if (!A) return

			if (--src.hits <= 0)
				if(prob(15) && !istype(A, /obj/structure/grille))
					explosion(src.loc, 1, 2, 3, 4, 0)
					playsound(src.loc, "explosion", 50, 1)
				else
					makematerials(1)
				del(src)
			else
				explosion(src.loc, 0, 1, 2, 3, 0)
				playsound(src.loc, 'meteorimpact.ogg', 40, 1)
		return

	uranium
		icon_state = "glowing"
		genmaterials = list(/turf/simulated/mineral/uranium)

/obj/effect/meteor/huge
	name = "huge fucking meteor"
	icon = '96x96.dmi'
	icon_state = "meteor"
	hits = 5
	pixel_x = -32
	pixel_y = -32

	ex_act(severity)
		return

	Bump(atom/A)
		spawn(0)
			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
					shake_camera(M, 3, 3)
			if (!A) return

			if (--src.hits <= 0)
				playsound(src.loc, "explosion", 50, 1)
				makematerials(4)
				del(src)
			else
				explosion(src.loc, 0, 1, 2, 3, 0)
				playsound(src.loc, 'meteorimpact.ogg', 40, 1)
		return

	ice
		icon_state = "frostmeteor"
		hits = 1
		genmaterials = list(/obj/structure/icewall)

		Bump(atom/A)
			spawn(0)
				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
						shake_camera(M, 3, 3)
				if (!A) return

				if (--src.hits <= 0)
					playsound(src.loc, "explosion", 50, 1)
					makematerials(4,2)
					del(src)
				else
					explosion(src.loc, 0, 1, 2, 3, 0)
					playsound(src.loc, 'meteorimpact.ogg', 40, 1)
			return

/obj/effect/meteor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pickaxe)) //Badass.
		del(src)
		return
	..()

/obj/materialmaker
	mouse_opacity = 0
	unacidable = 1//So effect are not targeted by alien acid.
	flags = TABLEPASS
	var/genmaterials = list(/turf/simulated/mineral/random/high_chance)

	ex_act(severity)
		return 0

