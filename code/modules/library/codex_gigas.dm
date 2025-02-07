/obj/item/book/codex_gigas
	name = "Codex Gigas"
	icon_state ="demonomicon"
	throw_speed = 1
	throw_range = 10
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	author = "Forces beyond your comprehension"
	unique = TRUE
	title = "The codex gigas"
	var/inUse = 0


/obj/item/book/codex_gigas/attack_self(mob/user)
	if(!user.has_vision())
		return
	if(inUse)
		to_chat(user,"<span class='notice'>Someone else is reading it.</span>")
		return
	if(!user.is_literate())
		to_chat(user,"<span class='notice'>You don't know how to read.</span>")
		return
	if(ishuman(user))
		var/mob/living/carbon/human/U = user
		if(U.check_acedia())
			to_chat(user,"<span class='notice'>None of this matters, why are you reading this?  You put the [title] down.</span>")
			return
		inUse = 1
		var/devilName = copytext(sanitize(input(user, "What infernal being do you wish to research?", "Codex Gigas", null)  as text),1,MAX_MESSAGE_LEN)
		var/speed = 30 SECONDS
		var/correctness = 85
		var/willpower = 95
		if(U.job in list(JOB_TITLE_LIBRARIAN)) // the librarian is both faster, and more accurate than normal crew members at research
			speed = 4.5 SECONDS
			correctness = 100
			willpower = 100
		if(U.job in list(JOB_TITLE_CHAPLAIN)) // the librarian is both faster, and more accurate than normal crew members at research
			speed = 30 SECONDS
			correctness = 100
		if(U.job in list(JOB_TITLE_CAPTAIN, JOB_TITLE_OFFICER, JOB_TITLE_HOS, JOB_TITLE_DETECTIVE, JOB_TITLE_WARDEN))
			willpower = 99
		if(U.job in list(JOB_TITLE_CLOWN)) // WHO GAVE THE CLOWN A DEMONOMICON?  BAD THINGS WILL HAPPEN!
			willpower = 25
		correctness -= U.getBrainLoss() *0.5 //Brain damage makes researching hard.
		speed += U.getBrainLoss() * 0.3 SECONDS
		user.visible_message("[user] opens [title] and begins reading intently.")
		if(do_after(U, speed, U, DEFAULT_DOAFTER_IGNORE|IGNORE_HELD_ITEM))
			var/usedName = devilName
			if(!prob(correctness))
				usedName += "x"
			var/datum/devilinfo/devil = devilInfo(usedName, 0)
			user << browse("Information on [devilName]<br><br><br>[GLOB.lawlorify[LORE][devil.ban]]<br>[GLOB.lawlorify[LORE][devil.bane]]<br>[GLOB.lawlorify[LORE][devil.obligation]]<br>[GLOB.lawlorify[LORE][devil.banish]]", "window=book")
		inUse = 0
		sleep(10)
		if(!prob(willpower))
			U.influenceSin()
		onclose(user, "book")
