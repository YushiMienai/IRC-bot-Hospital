proc hos:proles {nick uhost handle chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {$hosp(isgame)==0} {return}
	set i 0
	foreach val $hosp(psy) {
		if {[hos:free $val]} {incr i}
	}
	set mes ""
	if {$i>0} {set mes "\00314Мирных психов -\0033 $i\00314."}
	set i 0
	foreach val $hosp(san) {
		if {[hos:free $val]} {incr i}
	}
	if {$i>0} {set mes [lappend mes "\00314Санитаров -\0033 $i\00314."]}
	if {[hos:free $hosp(main)]} {set mes [lappend mes "Главврач."]}
	if {[hos:free $hosp(sis)]} {set mes [lappend mes "Медсестра."]}
	if {[hos:free $hosp(shiz)]} {set mes [lappend mes "Шизофреник."]}
	if {[hos:free $hosp(nev)]} {set mes [lappend mes "Невропатолог."]}
	if {[hos:free $hosp(sym)]} {set mes [lappend mes "Симулянт."]}
	if {[hos:free $hosp(nim)]} {set mes [lappend mes "Нимфоманка."]}
	if {[hos:free $hosp(mad)]} {set mes [lappend mes "Буйный."]}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mroles {nick uhost handle text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	set i 0
	foreach val $hosp(psy) {
		if {[hos:free $val]} {incr i}
	}
	set mes ""
	if {$i>0} {set mes "\00314Мирных психов -\0033 $i\00314."}
	set i 0
	foreach val $hosp(san) {
		if {[hos:free $val]} {incr i}
	}
	if {$i>0} {set mes [lappend mes "\00314Санитаров -\0033 $i\00314."]}
	if {[hos:free $hosp(main)]} {set mes [lappend mes "Главврач."]}
	if {[hos:free $hosp(sis)]} {set mes [lappend mes "Медсестра."]}
	if {[hos:free $hosp(shiz)]} {set mes [lappend mes "Шизофреник."]}
	if {[hos:free $hosp(nev)]} {set mes [lappend mes "Невропатолок."]}
	if {[hos:free $hosp(sym)]} {set mes [lappend mes "Симулянт."]}
	if {[hos:free $hosp(nim)]} {set mes [lappend mes "Нимфоманка."]}
	if {[hos:free $hosp(mad)]} {set mes [lappend mes "Буйный."]}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $nick :$mes"
}

proc hos:plist {nick uhost handle chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {$hosp(isgame)==0} {return}
	if {$hosp(players)==""} {
		putserv "PRIVMSG $chan :Список пуст"
		return
	}
	set mes "\00314В игре: "
	set i 1
	if {$hosp(isreg)} {
		foreach val $hosp(players) {
			set mes [lappend mes "$i. \0035$val\00314"]
			incr i
		}
	} else {
		foreach val $hosp(gplayers) {
			set mes [lappend mes "$i. \0035$val\00314"]
			incr i
		}
	}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $chan :$mes"
}

proc hos:mlist {nick uhost handle text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {$hosp(players)==""} {
		putserv "PRIVMSG $chan :Список пуст"
		return
	}
	set mes "\00314В игре: "
	set i 1
	if {$hosp(isreg)} {
		foreach val $hosp(players) {
			set mes [lappend mes "$i. \0035$val\00314"]
			incr i
		}
	} else {
		foreach val $hosp(gplayers) {
			set mes [lappend mes "$i. \0035$val\00314"]
			incr i
		}
	}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $nick :$mes"
}

proc hos:setroles {} {
	global hosp
	set hosp(psy) ""
	set hosp(main) "" 
	set hosp(sis) ""
	set hosp(nev) ""
	set hosp(san) ""
	set hosp(sym) ""
	set hosp(shiz) ""
	set hosp(nim) ""
	set hosp(mad) ""
	set hosp(nimpriv) ""
	set hosp(nummain) 1
	set hosp(numsis) 1
	set hosp(numsan) [expr round(([llength $hosp(players)]-2)/3.0)]
	if {$hosp(numsan)<1} {set hosp(numsan) 1}
	if {$hosp(numsan)>6} {set hosp(numsan) 6}
#	set hosp(numnev) [expr round(([llength $hosp(players)]-4)/5.0)]
	if {[llength $hosp(gplayers)]>8} {set hosp(numnev) 1}
#	set hosp(numshiz) [expr round(([llength $hosp(players)]-3)/6.0)]
	if {[llength $hosp(gplayers)]>4} {set hosp(numshiz) 1}
	if {[llength $hosp(players)]>5} {set hosp(numshiz) 1}
	if {[llength $hosp(players)]>9} {set hosp(numnim) 1}
	if {[llength $hosp(players)]>10} {set hosp(numsym) 1}
	if {[llength $hosp(players)]>11} {set hosp(nummad) 1}
	set hosp(numpsy) [expr [llength $hosp(players)]-$hosp(nummain)-$hosp(numsis)-$hosp(numsan)-$hosp(numnev)-$hosp(numshiz)-$hosp(numnim)-$hosp(numsym)-$hosp(nummad)]
	set hosp(all) $hosp(numpsy)
	set mes "Всего в игре: мирных психов - $hosp(numpsy), санитаров - $hosp(numsan), главврач, медсестра,"
	if {$hosp(numshiz)>0} {set mes [lappend mes "шизофреник,"]}
	if {$hosp(numsym)>0} {set mes [lappend mes "симулянт,"]}
	if {$hosp(numnev)>0} {set mes [lappend mes "невпропатолог,"]}
	if {$hosp(numnim)>0} {set mes [lappend mes "нимфоманка,"]}
	if {$hosp(nummad)>0} {set mes [lappend mes "буйный,"]}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
	if {$hosp(numshiz)} {
		set hosp(numzag) [expr round ([llength $hosp(gplayers)]/6)]
		if {$hosp(numzag)<1} {set hosp(numzag) 1}
	}
	hos:giveroles
}

proc hos:giveroles {} {
	global hosp

	set players $hosp(players)
	#Роль главврача
	set t [rand [llength $players]]
	set tnick [lindex $players $t]
	set hosp(main) $tnick
	putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Главврач\003."
	set new ""
	foreach val $players {
		if {$val!=$tnick} {set new [lappend new $val]}
	}
	hos:frole $tnick main
	set players $new
	
	#Медсестра
	set j 1
	while {$j} {
		set tnick [lindex $players [rand [llength $players]]]
		set hosp(sis) $tnick
		putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Медсестра\003."
		set j 0
		set new ""
		foreach val $players {
			if {$val!=$tnick} {set new [lappend new $val]}
		}
		set players $new
	}
	hos:frole $tnick sis
	
	#Санитар
	for {set i 0} {$i<$hosp(numsan)} {incr i} {
		set j 1
		while {$j} {
			set tnick [lindex $players [rand [llength $players]]]
			set hosp(san) [lappend hosp(san) $tnick]
			putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Санитар\003."
			set j 0
			set new ""
			foreach val $players {
				if {$val!=$tnick} {set new [lappend new $val]}
			}
			set players $new
		}
		hos:frole $tnick san
	}

	#Шизофреник
	for {set i 0} {$i<$hosp(numshiz)} {incr i} {
		set j 1
		while {$j} {
			set tnick [lindex $players [rand [llength $players]]]
			set hosp(shiz) [lappend hosp(shiz) $tnick]
			putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Шизофреник\003."
			set j 0
			set new ""
			foreach val $players {
				if {$val!=$tnick} {set new [lappend new $val]}
			}
			set players $new
		}
		hos:frole $tnick shiz
	}

	#Невропатолог
	set j 1
	while {$j && $hosp(numnev)} {
		set tnick [lindex $players [rand [llength $players]]]
		set hosp(nev) $tnick
		putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Невропатолог\003."
		set j 0
		set new ""
		foreach val $players {
			if {$val!=$tnick} {set new [lappend new $val]}
		}
		set players $new
		hos:frole $tnick nev
	}

	
	#Нимфоманка
	set j 1
	while {$j && $hosp(numnim)} {
		set tnick [lindex $players [rand [llength $players]]]
		set hosp(nim) $tnick
		putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Нимфоманка\003."
		set j 0
		set new ""
		foreach val $players {
			if {$val!=$tnick} {set new [lappend new $val]}
		}
		set players $new
		hos:frole $tnick nim
	}
	
	#Буйный
	set j 1
	while {$j && $hosp(nummad)} {
		set tnick [lindex $players [rand [llength $players]]]
		set hosp(mad) $tnick
		putserv "PRIVMSG $tnick :\0037$tnick\003, ваша роль \0034Буйный\003."
		set j 0
		set new ""
		foreach val $players {
			if {$val!=$tnick} {set new [lappend new $val]}
		}
		set players $new
		hos:frole $tnick mad
	}

	#Мирный псих
	foreach val $players {
		set hosp(psy) [lappend hosp(psy) $val]
		putserv "PRIVMSG $val :\0037$val\003, ваша роль \0034Мирный псих\003."
		hos:frole $val psy 
	}
	foreach val $hosp(players) {hos:aliance $val}
	set hosp(qsan) 1
	set hosp(gplayers) $hosp(players)
	hos:night
}

proc hos:alnc {nick uhost handle text} {
	if {[hos:free $nick]} {hos:aliance $nick}
}

proc hos:aliance {nick} {
	global hosp

	set role [hos:getrole $nick]
	switch -exact -- $role {
		"main" {
			if {$hosp(nev)!=""} {putserv "PRIVMSG $nick :\0037$hosp(nev)\003 - \0034Невропатолог\003."}
		}
		"nev" {putserv "PRIVMSG $nick :\0037$hosp(main)\003 - \0034Главврач\003."}
		"san" {
			set san ""
			if {[llength $hosp(san)]>1} {
				set san "Санитары: "
				foreach val $hosp(san) {
					if {$val != $nick} {set san [lappend san "\0034$val\003."]}
				}
			}
			if {$hosp(sym)!=""} {set san [lappend san " \0037Симулянт\003 - \0034$hosp(sym)\003."]}
			if {$san!=""} {putserv "PRIVMSG $nick :$san"}
		}
		"sym" {
			set san ""
			foreach val $hosp(san) {set san [lappend san "\0034$nick\003."]}
			putserv "PRIVMSG $nick :\0037Санитары\003: $san"
		}
	}
}
