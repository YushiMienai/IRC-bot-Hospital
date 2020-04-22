proc hos:pturns {nick uhost hand chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {$hosp(night)==0} {return}
	set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
	set mes "\00314Не сделали свои ходы:"
	if {!$hosp(maind) && [hos:free $hosp(main)]} {set mes [lappend mes "\0033Главврач\00314."]}
	if {!$hosp(sisd) && [hos:free $hosp(sis)]} {set mes [lappend mes "\0033Медсестра\00314."]}
	if {!$hosp(nevd) && [hos:free $hosp(nev)]} {set mes [lappend mes "\0033Невропатолог\00314."]}
	if {!$hosp(sand) && [hos:free $san]} {set mes [lappend mes "\0033Санитар\00314."]}
	if {!$hosp(symd) && [hos:free $hosp(sym)]} {set mes [lappend mes "\0033Симулянт\00314."]}
	if {!$hosp(nimd) && [hos:free $hosp(nim)]} {set mes [lappend mes "\0033Нимфоманка\00314."]}
	if {!$hosp(shizd) && [hos:free $hosp(shiz)]} {set mes [lappend mes "\0033Шизофреник\00314."]}
	if {!$hosp(madd) && [hos:free $hosp(mad)]} {set mes [lappend mes "\0033Буйный\00314."]} 
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mturns {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
	set mes "\00314Не сделали свои ходы:"
	if {!$hosp(maind) && [hos:free $hosp(main)]} {set mes [lappend mes "\0033Главврач\00314."]}
	if {!$hosp(sisd) && [hos:free $hosp(sis)]} {set mes [lappend mes "\0033Медсестра\00314."]}
	if {!$hosp(nevd) && [hos:free $hosp(nev)]} {set mes [lappend mes "\0033Невропатолог\00314."]}
	if {!$hosp(sand) && [hos:free $san]} {set mes [lappend mes "\0033Санитар\00314."]}
	if {!$hosp(symd) && [hos:free $hosp(sym)]} {set mes [lappend mes "\0033Симулянт\00314."]}
	if {!$hosp(nimd) && [hos:free $hosp(nim)]} {set mes [lappend mes "\0033Нимфоманка\00314."]}
	if {!$hosp(shizd) && [hos:free $hosp(shiz)]} {set mes [lappend mes "\0033Шизофреник\00314."]}
	if {!$hosp(madd) && [hos:free $hosp(mad)]} {set mes [lappend mes "\0033Буйный\00314."]} 
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $nick :$mes"
}

proc hos:night {} {
	global hosp
	hos:kick
	set hosp(night) 1
#	set hosp(rask) 0
	if {[hos:free $hosp(main)]} {set hosp(maind) 0} else {set hosp(maind) 1}
	if {[hos:free $hosp(sis)]} {set hosp(sisd) 0} else {set hosp(sisd) 1}
	if {[hos:free $hosp(nev)]} {set hosp(nevd) 0} else {set hosp(nevd) 1}
	set hosp(sand) 1
	foreach val $hosp(san) {
		if {[hos:free $hosp(san)]} {set hosp(sand) 0} 
	}
	if {[hos:free $hosp(sym)]} {set hosp(symd) 0} else {set hosp(symd) 1}
	if {[hos:free $hosp(shiz)]} {set hosp(shizd) 0} else {set hosp(shizd) 1}
	if {[hos:free $hosp(nim)]} {set hosp(nimd) 0} else {set hosp(nimd) 1}
	if {[hos:free $hosp(mad)] && ($hosp(wmadiz) || $hosp(wmadch) || $hosp(madpr))} {set hosp(madd) 0} else {set hosp(madd) 1}
	set msg {
		{Ночь, не ночь - хз... Вобщем действуйте, господа.}
		{Наступила ночь. Роли, пора делать ходы, если никто не хочет оказаться в изоляторе.}
	}
	set mmsg [lindex $msg [rand [llength $msg]]]
	putserv "PRIVMSG $hosp(chan) :\00314$mmsg"
	foreach val $hosp(gplayers) {
		set mes "Список: "
		set i 1
		foreach kkk $hosp(gplayers) {
			set mes [lappend mes "$i. \0034$kkk\003."]
			incr i
		}
#		regsub -all -- {\{} $mes {} mes
#		regsub -all -- {\}} $mes {} mes
		set mes [hos:mes $mes]
		set rol [hos:getrole $val]
		switch -exact -- $rol {
			"main" {
				putserv "PRIVMSG $val :!<изолировать/isolate> <Ник/номер> <фраза>, !<проверить/check> <Ник/номер> <фраза>"
				putserv "PRIVMSG $val :$mes"
			}
			"sis" {
				putserv "PRIVMSG $val :!<помочь/help> <Ник/номер> <фраза>"
				putserv "PRIVMSG $val :$mes"
			}
			"san" {
				set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
				if {$val==$san} {
					putserv "PRIVMSG $val :!<избить/beat> <Ник/номер> <фраза>"
					putserv "PRIVMSG $val :$mes"
				}
			}
			"sym" {
				putserv "PRIVMSG $val :!<проверить/check> <Ник/номер> <фраза>"
				putserv "PRIVMSG $val :$mes"
			}
			"nim" {
				putserv "PRIVMSG $val :!<соблазнить/tempt> <Ник/номер> <фраза>"
				putserv "PRIVMSG $val :$mes"
			}
			"shiz" {
				putserv "PRIVMSG $val :!<изолировать/isolate> <Ник/номер> <фраза>, !<заговорить/crazy> <фраза> <Ник/номер> (еще\0034 $hosp(numzag)\00314 раз)"
				putserv "PRIVMSG $val :$mes"
			}
			"nev" {
				putserv "PRIVMSG $val :!<изолировать/isolate> <Ник/номер> <фраза>\0035 (если нет главврача)\00314, !<проверить\check> <Ник/номер> <фрраза>"
				putserv "PRIVMSG $val :$mes"
			}
			"mad" {
				if {$hosp(wmadiz)!=""} {
					set mes "Список избиений (писать - !!<избить/beat> <номер заказа> <фраза>): "
					set i 0
					foreach val $hosp(wmadiz) {
						set vic [lindex $hosp(madiz) $i]
						set summ [lindex $hosp(smadiz) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
				}
				if {$hosp(wmadch)!=""} {
					set mes "Список проверок (писать - !!<проверить/check> <номер заказа> <фраза>): "
					set i 0
					foreach val $hosp(wmadch) {
						set vic [lindex $hosp(madch) $i]
						set summ [lindex $hosp(smadch) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
				}
				if {$hosp(wmadpr)!=""} {
					set mes "Список защит (писать - !!<защитить/protect> <номер заказа> <фраза>): "
					set i 0
					foreach val $hosp(wmadpr) {
						set vic [lindex $hosp(madpr) $i]
						set summ [lindex $hosp(smadpr) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
				}
#				regsub -all -- {\{} $mes {} mes
#				regsub -all -- {\}} $mes {} mes
				set mes [hos:mes $mes]
				putserv "PRIVMSG $hosp(mad) :$mes"
			}
		}
	}
	utimer 60 hos:night1
}

proc hos:night1 {} {
	global hosp
	putserv "PRIVMSG $hosp(chan) :\0035Внимание! Осталась еще две минуты."
	utimer 60 hos:night2
}

proc hos:night2 {} {
	global hosp
	putserv "PRIVMSG $hosp(chan) :\0035Внимание! Осталась еще одна минута."
	utimer 60 hos:morn
}

proc hos:getrole {nick} {
	global hosp
	foreach val $hosp(main) {
		if {$nick==$val} {return "main"}
	}
	foreach val $hosp(sis) {
		if {$nick==$val} {return "sis"}
	}
	foreach val $hosp(san) {
		if {$nick==$val} {return "san"}
	}
	foreach val $hosp(nev) {
		if {$nick==$val} {return "nev"}
	}
	foreach val $hosp(sym) {
		if {$nick==$val} {return "sym"}
	}
	foreach val $hosp(shiz) {
		if {$nick==$val} {return "shiz"}
	}
	foreach val $hosp(mad) {
		if {$nick==$val} {return "mad"}
	}
	foreach val $hosp(nim) {
		if {$nick==$val} {return "nim"}
	}
	foreach val $hosp(psy) {
		if {$nick==$val} {return "psy"}
	}
	return ""
}

proc hos:wrole {nick uhost handle text} {
	if {[hos:free $nick]} {set role [hos:getrole $nick]} else {return}
	switch -exact -- $role {
		main {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Главврач\00314."}
		nev {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Невропатолог\00314."}
		sis {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Медсестра\00314."}
		psy {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Мирный псих\00314."}
		san {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Санитар\00314."}
		sym {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Симулянт\00314."}
		mad {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Буйный\00314."}
		nim {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Нимфоманка\00314."}
		shiz {putserv "PRIVMSG $nick :\00314Вы,\0033 $nick\00314 -\0032 Шизофреник\00314."}
	}
}

proc hos:free {nick} {
	global hosp
	foreach val $hosp(gplayers) {
		if {$nick==$val} {return 1}
	}
	return 0
}

proc hos:alldone {} {
	global hosp

	if {$hosp(maind) && $hosp(sisd) && $hosp(nevd) && $hosp(sand) && $hosp(symd) && $hosp(nimd) && $hosp(shizd) && $hosp(madd)} {return 1}
	return 0
}

proc hos:isnum {arg} {
	global hosp
	for {set i 0} {$i<[llength $hosp(gplayers)]} {incr i} {
		if {$arg==[expr $i+1]} {return 1}
	}
	return 0
}

proc hos:check {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(main)!=$nick && $hosp(nev)!=$nick && $hosp(sym)!=$nick} {return}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [lindex $hosp(gplayers) [expr $vic-1]]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(main)==$nick} {
		if {$hosp(maind)==0} {putserv "PRIVMSG $hosp(chan) :\00314На ночь глядя Главврач заперся у себя в кабинете с кофеваркой и стопкой документов."}
		set hosp(wmain) $vic
		set hosp(wmaini) 2
		set hosp(maind) 1
		set hosp(fmain) $say
	}
	if {$hosp(nev)==$nick} {
		if {$hosp(nevd)==0} {	putserv "PRIVMSG $hosp(chan) :\00314Невропатолог проводит бессонную ночь в своём кабинете, роясь в стопке разных бумаг."}
		set hosp(wnev) $vic
		set hosp(wnevi) 2
		set hosp(nevd) 1
		set hosp(fnev) $say
	}
	if {$hosp(sym)==$nick} {
		if {$hosp(symd)==0} {putserv "PRIVMSG $hosp(chan) :\00314Симулянт пробрался в кабинет Главврача, чтобы помочь злым Санитарам в поиске цели."}
		set hosp(wsym) $vic
		set hosp(symd) 1
		set hosp(fsym) $say
	}
	putserv "PRIVMSG $nick :Заказ на проверку \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :\00314Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:isol {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(main)!=$nick && $hosp(nev)!=$nick && $hosp(shiz)!=$nick} {return}
	if {[hos:free $hosp(main)] && [hos:getrole $nick]=="nev"} {return}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [lindex $hosp(gplayers) [expr $vic-1]]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(nev)==$nick} {
		if {$hosp(nevd)==0} {	putserv "PRIVMSG $hosp(chan) :\00314Невропатолог отправился совершать ночной обход, прихватив с собой на всякий случай шприц с транквилизатором."}
		set hosp(wnev) $vic
		set hosp(wnevi) 1
		set hosp(nevd) 1
		set hos(fnev) $say
	}
	if {$hosp(main)==$nick} {
		if {$hosp(maind)==0} {putserv "PRIVMSG $hosp(chan) :\00314Главврач, дёрнув для храбрости 50г коньяку, отправился на ночной обход."}
		set hosp(wmain) $vic
		set hosp(wmaini) 1
		set hosp(maind) 1
		set hosp(fmain) $say
	}
	if {$hosp(shiz)==$nick} {
		if {$hosp(shizd)==0} {putserv "PRIVMSG $hosp(chan) :\00314Шизофреник подкарауливает кого-то в тёмном коридоре."}
		set hosp(wshiz) $vic
		set hosp(wshizi) 1
		set hosp(shizd) 1
		set hosp(fshiz) $say
	}
	putserv "PRIVMSG $nick :Заказ на изолирование \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:sobl {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(nim)!=$nick} {return}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [expr $vic-1]
		set vic [lindex $hosp(gplayers) $vic]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(nimd)==0} {putserv "PRIVMSG $hosp(chan) :Походила нимфоманка"}
	set hosp(nimd) 1
	set hosp(fnim) $say
	set hosp(wnim) $vic
	putserv "PRIVMSG $nick :Заказ на соблазнение \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:izbit {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
	if {$nick != $san} {return}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [lindex $hosp(gplayers) [expr $vic-1]]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(sand)==0} {putserv "PRIVMSG $hosp(chan) :\00314Санитары собрались в подсобке, чтобы решить, кто этой ночью окажется в травматологии."}
	set hosp(wsan) $vic
	set hosp(fsan) $say
	set hosp(sand) 1
	putserv "PRIVMSG $nick :Заказ на избиение \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:crazy {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(shiz)!=$nick} {return}
	if {$hosp(numzag)==0} {
		putserv "PRIVMSG $nick :\002\00314Вы не можете больше сводить с ума своих жертв."
		return
	}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [expr $vic-1]
		set vic [lindex $hosp(gplayers) $vic]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(shizd)==0} {putserv "PRIVMSG $hosp(chan) :\00314Хитрый Шизик бормочет что-то себе под нос, подыскивая жертву."}
	set hosp(wshiz) $vic
	set hosp(shizd) 1
	set hosp(wshizi) 2
	set hosp(fshiz) $say
	putserv "PRIVMSG $nick :Заказ на заговорение \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:rask {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(shiz)!=$nick} {return}
	if {$hosp(shizd)==0} {putserv "PRIVMSG $hosp(chan) :Походил шизофреник"}
	set hosp(wshizi) 3
	putserv "PRIVMSG $nick :Заказ на раскаяние принят."
	if {[hos:alldone]} {
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:heal {nick uhost hand text} {
	global hosp
	if {$hosp(night)==0} {return}
	if {![hos:free $nick]} {return}
	if {$hosp(sis)!=$nick} {return}
	set vic [lindex $text 1]
	set say ""
	for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
	if {[hos:isnum $vic]} {
		set vic [expr $vic-1]
		set vic [lindex $hosp(gplayers) $vic]
	}
	if {![hos:free $vic]} {
		putserv "PRIVMSG $nick :Такого человека в игре нет."
		return
	}
	if {$hosp(sisd)==0} {putserv "PRIVMSG $hosp(chan) :\00314Медсестра неслышно крадётся по ночным коридорам в надежде спасти хоть кого-нибудь."}
	set hosp(wsis) $vic
	set hosp(sisd) 1
	set hosp(fsis) $say
	putserv "PRIVMSG $nick :Заказ на лечение \0037$vic\003 принят."
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:sum {arg} {
	for {set i 20} {$i<3000} {incr i} {
		if {$arg==$i} {return 1}
	}
	return 0
}

proc hos:madiz {nick uhost hand text} {
	global hosp
	if {![hos:free $nick]} {return}
	if {![hos:free $hosp(mad)]} {return}
	set com [lindex $text 0]
	set vic [lindex $text 1]
	if {$hosp(mad)!=$nick} {
		set summ [lindex $text 2]
		if {[hos:isnum $vic]} {
			set vic [lindex $hosp(gplayers) [expr $vic-1]]
		}
		if {![hos:free $vic]} {
			putserv "PRIVMSG $nick :\00314Такого человека нет в игре."
			return
		}
		if {![hos:sum $summ]} {
			putserv "PRIVMSG $nick :\00314Введите количество тоблеток (от 20 до 3000)"
			return
		}
		set did 0
		set i 0
		switch -exact -- $com {
			"!!избить" {
				foreach val $hosp(wmadiz) {
					if {$val==$nick} {
						set did 1
						break
					}
					incr i
				}
				if {$did} {
					set hosp(madiz) [lreplace $hosp(madiz) $i $i $vic]
					set hosp(smadiz) [lreplace $hosp(smadiz) $i $i $summ]
				} else {
					set hosp(wmadiz) [lappend hosp(wmadiz) $nick]
					set hosp(madiz) [lappend hosp(madiz) $vic]
					set hosp(smadiz) [lappend hosp(smadiz) $summ]
				}
				putserv "PRIVMSG $nick :Заказ на избиение \0034$vic\003 за \0038 $summ\003 принят."
				if {$hosp(night)} {
					putserv "PRIVMSG $hosp(mad) :Обновился список заказов на избиение."
					set mes "Список (писать - !!избить <номер заказа>): "
					set i 0
					foreach val $hosp(wmadiz) {
						set vic [lindex $hosp(madiz) $i]
						set summ [lindex $hosp(smadiz) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
#					regsub -all -- {\{} $mes {} mes
#					regsub -all -- {\}} $mes {} mes
					set mes [hos:mes $mes]
					putserv "PRIVMSG $hosp(mad) :$mes"
				}
			}
			"!!проверить" {
				foreach val $hosp(wmadch) {
					if {$val==$nick} {
						set did 1
						break
					}
					incr i
				}
				if {$did} {
					set hosp(madch) [lreplace $hosp(madch) $i $i $vic]
					set hosp(smadch) [lreplace $hosp(smadch) $i $i $summ]
				} else {
					set hosp(wmadch) [lappend hosp(wmadch) $nick]
					set hosp(madch) [lappend hosp(madch) $vic]
					set hosp(smadch) [lappend hosp(smadch) $summ]
				}
				putserv "PRIVMSG $nick :Заказ на проверку \0034$vic\003 за \0038 $summ\003 таблеток принят."
				if {$hosp(night)} {
					putserv "PRIVMSG $hosp(mad) :Обновился список заказов на избиение."
					set mes "Список (писать - !!проверить <номер заказа>): "
					set i 0
					foreach val $hosp(wmadch) {
						set vic [lindex $hosp(madch) $i]
						set summ [lindex $hosp(smadch) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
#					regsub -all -- {\{} $mes {} mes
#					regsub -all -- {\}} $mes {} mes
					set mes [hos:mes $mes]
					putserv "PRIVMSG $hosp(mad) :$mes"
				}
			}
			"!!защитить" {
				foreach val $hosp(wmadpr) {
					if {$val==$nick} {
						set did 1
						break
					}
					incr i
				}
				if {$did} {
					set hosp(madpr) [lreplace $hosp(madpr) $i $i $vic]
					set hosp(smadpr) [lreplace $hosp(smadpr) $i $i $summ]
				} else {
					set hosp(wmadpr) [lappend hosp(wmadpr) $nick]
					set hosp(madpr) [lappend hosp(madpr) $vic]
					set hosp(smadpr) [lappend hosp(smadpr) $summ]
				}
				putserv "PRIVMSG $nick :Заказ на защиту \0034$vic\003 за \0038 $summ\003 таблеток принят."
				if {$hosp(night)} {
					putserv "PRIVMSG $hosp(mad) :Обновился список заказов на избиение."
					set mes "Список (писать - !!защитить <номер заказа>): "
					set i 0
					foreach val $hosp(wmadpr) {
						set vic [lindex $hosp(madpr) $i]
						set summ [lindex $hosp(smadpr) $i]
						set t [expr $i+1]
						set mes [lappend mes "$t. \0034$vic\003 - \0038 $summ\003."]
						incr i
					}
#					regsub -all -- {\{} $mes {} mes
#					regsub -all -- {\}} $mes {} mes
					set mes [hos:mes $mes]
					putserv "PRIVMSG $hosp(mad) :$mes"
				}
			}
		}
		if {$hosp(wmad)==""} {set hosp(madd) 0}
	} else {
		if {$hosp(night)==0} {return}
		set say ""
		for {set i 2} {$i<[llength $text]} {incr i} {set say [lappend say [lindex $text $i]]}
		switch -exact -- $com {
			"!!избить" {
				set vict [lindex $hosp(madiz) [expr $vic-1]]
				set summ [lindex $hosp(smadiz) [expr $vic-1]]
				set ord [lindex $hosp(wmadiz) [expr $vic-1]]
				set hosp(wmad) "$vict $summ $ord"
				set hosp(madi) 1
				putserv "PRIVMSG $hosp(mad) :Заказ на избиение \0034$vict\003 за \0038 $summ\003 таблеток принят."
			}
			"!!проверить" {
				set vict [lindex $hosp(madch) [expr $vic-1]]
				set summ [lindex $hosp(smadch) [expr $vic-1]]
				set ord [lindex $hosp(wmadch) [expr $vic-1]]
				set hosp(wmad) "$vict $summ $ord"
				set hosp(madi) 2
				putserv "PRIVMSG $hosp(mad) :Заказ на проверку \0034$vict\003 за \0038 $summ\003 таблеток принят."
			}
			"!!защитить" {
				set vict [lindex $hosp(madpr) [expr $vic-1]]
				set summ [lindex $hosp(smadpr) [expr $vic-1]]
				set ord [lindex $hosp(wmadpr) [expr $vic-1]]
				set hosp(wmad) "$vict $summ $ord"
				set hosp(madi) 3
				putserv "PRIVMSG $hosp(mad) :Заказ на защиту \0034$vict\003 за \0038 $summ\003 принят."
			}
		}
		putlog $hosp(wmad)
		if {$hosp(madd)==0} {putserv "PRIVMSG $hosp(chan) :Походил буйный."}
		set hosp(madd) 1
		set hosp(fmad) $say
	}
	if {[hos:alldone]} {
		set hosp(night) 0
		putserv "PRIVMSG $hosp(chan) :Утро наступит через 5 секунд."
		hos:killtimers
		utimer 5 hos:morn
	}
}

proc hos:say {nick uhost hand text} {
	global hosp
	if {![hos:free $nick]} {return}
	set role [hos:getrole $nick]
	switch -exact -- $role {
		"psy" {set mes "\0034Мирный псих:"}
		"main" {set mes "\0034Главврач:"}
		"sis" {set mes "\0034Медсестра:"}
		"nev" {set mes "\0034Невропатолог:"}
		"san" {set mes "\0034Санитар:"}
		"sym" {set mes "\0034Симулянт:"}
		"shiz" {set mes "\0034Шизофреник:"}
		"nim" {set mes "\0034Нимфоманка:"}
		"mad" {set mes "\0034Буйный:"}
	}
	set fr ""
	foreach val $text {
		if {$val!=[lindex $text 0]} {set fr [lappend fr $val]}
	}
	if {$fr!="" } {
		set mes [lappend mes "\00310 $fr"]
#		regsub -all -- {\{} $mes {} mes
#		regsub -all -- {\}} $mes {} mes
		set mes [hos:mes $mes]
		putserv "PRIVMSG $hosp(chan) :$mes"
	}
}
