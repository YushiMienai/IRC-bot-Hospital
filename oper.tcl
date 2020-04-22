proc hos:po {nick uhost handle chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn==""} {set wn $nick}
	if {![onchan $wn $hosp(chan)]} {return}
	if {[hos:isingame $wn]} {return}
	pushmode $hosp(chan) +o $wn
}

proc hos:mo {nick uhost handle text} {
	global hosp
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn==""} {set wn $nick}
	if {![onchan $wn $hosp(chan)]} {return}
	if {[hos:isingame $wn]} {return}
	pushmode $hosp(chan) +o $wn
}

proc hos:pdo {nick uhost handle chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn==""} {set wn $nick}
	if {![onchan $wn $hosp(chan)]} {return}
	pushmode $hosp(chan) -o $wn
}

proc hos:mdo {nick uhost handle text} {
	global hosp
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn==""} {set wn $nick}
	if {![onchan $wn $hosp(chan)]} {return}
	pushmode $hosp(chan) -o $wn
}

proc hos:pkick {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {$chan!=$hosp(chan)} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn=="" || ![onchan $wn $chan]} {return}
	putserv "PRIVMSG $hosp(chan) :\0033$wn\00314 был выкинут из игры."
	hos:del $wn
	if {$hosp(night)} {
		set role [hos:getrole $wn]
		switch -exact -- $role {
			main	{set hosp(maind) 1}
			sis {set hosp(sisd) 1}
			mad	{set hosp(madd) 1}
			sym {set hosp(symd) 1}
			shiz {set hosp(shizd) 1}
			san {set hosp(sand) 1}
			nim {set hosp(nimd) 1}
			nev {set hosp(nevd) 1}
		}
		if {[hos:alldone]} {
			putserv "PRIVMSG $hosp(chan) :”тро наступит через 5 секунд."
			hos:killtimers
			utimer 5 hos:morn
		}
	}
}

proc hos:mkick {nick uhost handle text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	set wn [lindex $text 1]
	if {$wn=="" || ![onchan $wn $hosp(chan)]} {return}
	putserv "PRIVMSG $hosp(chan) :\0033$wn\00314 был выкинут из игры."
	hos:del $wn
	if {$hosp(night)} {
		set role [hos:getrole $wn]
		switch -exact -- $role {
			main	{set hosp(maind) 1}
			sis {set hosp(sisd) 1}
			mad	{set hosp(madd) 1}
			sym {set hosp(symd) 1}
			shiz {set hosp(shizd) 1}
			san {set hosp(sand) 1}
			nim {set hosp(nimd) 1}
			nev {set hosp(nevd) 1}
		}
		if {[hos:alldone]} {
			putserv "PRIVMSG $hosp(chan) :”тро наступит через 5 секунд."
			hos:killtimers
			utimer 5 hos:morn
		}
	}
}

proc hos:pfurther {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {$chan!=$hosp(chan)} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	hos:killtimers
	if {$hosp(night)} {utimer 5 hos:morn}
	if {$hosp(isgolo1)} {utimer 5 hos:golocount}
	if {$hosp(isgolo2)} {utimer 5 hos:golo3}
}

proc hos:mfurther {nick uhost handle text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	hos:killtimers
	if {$hosp(night)} {utimer 5 hos:morn}
	if {$hosp(isgolo1)} {utimer 5 hos:golocount}
	if {$hosp(isgolo2)} {utimer 5 hos:golo3}
}


proc hos:nn {nick uhost handle text} {
	global hosp
	if {$hosp(isgame)==0} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<2} {return}
	utimer 1 hos:golo3
}

proc hos:rehash {nick uhost handle text} {
	global hosp
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	rehash
	return
}

proc hos:restart {nick uhost handle text} {
	global hosp
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	restart
	return
}

proc hos:jchan {nick uhost handle text} {
	global hosp
	set chanl [lindex $text 1]
	set frst [string range $chanl 0 0]
	if {$chanl=="" || $frst!="#"} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	channel add $chanl
	return
}

proc hos:pchan {nick uhost handle text} {
	global hosp
	set chanl [lindex $text 1]
	set frst [string range $chanl 0 0]
	if {$chanl=="" || $frst!="#"} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	channel remove $chanl
	return
}

proc hos:asay {nick uhost handle text} {
	global hosp
	set chanl [lindex $text 1]
	set frst [string range $chanl 0 0]
	set mes ""
	for {set i 2} {$i<[llength $text]} {incr i} {
		set mes [lappend mes [lindex $text $i]]
	}
	if {$chanl=="" || $frst!="#"} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	set mes [hos:mes $mes]
	if {$mes!=""} {
		putserv "PRIVMSG $chanl :$mes"
	}
	return
}

proc hos:act {nick uhost handle text} {
	global hosp
	set chanl [lindex $text 1]
	set frst [string range $chanl 0 0]
	set mes ""
	for {set i 2} {$i<[llength $text]} {incr i} {
		set mes [lappend mes [lindex $text $i]]
	}
	if {$chanl=="" || $frst!="#"} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	set mes [hos:mes $mes]
	if {$mes!=""} {
		putserv "PRIVMSG $chanl :\001ACTION $mes \001"
	}
	return
}

proc hos:barchan {nick uhost handle text} {
	global hosp
	set chanl [lindex $text 1]
	set frst [string range $chanl 0 0]
	if {$chanl=="" || $frst!="#"} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<3} {return}
	chanset $chanl -nopubbar
	return
}
