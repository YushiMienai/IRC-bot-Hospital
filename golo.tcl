proc hos:golo {} {
	global hosp
	set hosp(all) 0
	set hosp(morn) 0
	set hosp(isgolo1) 1
	set hosp(gmax) ""
	set hosp(qgmax) 0
	set hosp(dobl) 0
	set hosp(glplayers) ""
	set hosp(glwhom) ""
	set hosp(conf) ""
	putserv "PRIVMSG $hosp(chan) :\00314И так. Пришло время выяснить, кто виноват за беспорядок в больнице и изолировать его от общества. Голосование: \0034!<Ник/Номер>\00314 или \00314!!<ночь/night>\00314."
	set mes "\00314Список потенциальных виноватых:"
	set i 1
	foreach val $hosp(gplayers) {
		set mes [lappend mes "\00314 $i.\0035 $val"]
		incr i
	}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
	if {[hos:free $hosp(mad)]} {
		putserv "PRIVMSG $hosp(chan) :\00314Можно сделать заказы буйному: \0034!!<избить/защитить/проверить> <номер/ник> таблеток\00314. Изобьет подобно санитарам, защитит на голосовани или проверит игрока и приклеет его личное дело у всех на виду."
	}
	bind pubm - "$hosp(chan) !*" hos:gnick
	utimer 180 hos:golocount
}
# && $hosp(gmax)<[expr [llength $hosp(gplayers)]+1]
#
proc hos:golocount {} {
	global hosp
	unbind pubm - "$hosp(chan) !*" hos:gnick
	if {$hosp(dobl)==1 || $hosp(gmax)==[expr [llength $hosp(gplayers)]+1]} {
		putserv "PRIVMSG $hosp(chan) :\00314Никого не изолируем."
		utimer 5 hos:night
		return
	} elseif {$hosp(qgmax)>=[expr round ([llength $hosp(gplayers)]/2)]} {
		set hosp(conf) [lindex $hosp(gplayers) [expr $hosp(gmax)-1]]
		putserv "PRIVMSG $hosp(chan) :\00314Большинство считают, что\0034 $hosp(conf)\00314 виноват за беспорядки в больнице. Надо ли его изолировать? (\0034!<да/yes>\00314 или\0034 !<нет/no>\00314)."
		set hosp(glplayers) ""
		set hosp(glwhom) ""
		set hosp(isgolo2) 1
		bind pubm - "$hosp(chan) !да*" hos:yes
		bind pubm - "$hosp(chan) !yes*" hos:yes
		bind pubm - "$hosp(chan) !нет*" hos:no
		bind pubm - "$hosp(chan) !no*" hos:no
		utimer 120 hos:golo3
		return
	}
	putserv "PRIVMSG $hosp(chan) :\00314Никого не изолируем."
	utimer 5 hos:night
}

proc hos:gnick {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgolo1)==0} {return}
	if {![hos:free $nick]} {return}
	set t [lindex $text 0]
	set pers [string range $t 1 end]
	if {$pers==""} {return}
	if {[hos:isnum $pers]} {
		if {$pers>[llength $hosp(gplayers)] || $pers<1} {
#			putserv "PRIVMSG $hosp(chan) :\002\00314Такого человека как\0034 $pers\00314 нет в игре."
			return
		}
	} else {
		if {$pers=="!ночь" || $pers=="!night"} {
			set pers [expr [llength $hosp(gplayers)]+1]
		} elseif {[hos:free $pers]} {
			set pers [expr [lsearch -exact $hosp(gplayers) $pers]+1]
		} else {
#			putserv "PRIVMSG $hosp(chan) :\002\00314Такого человека как\0034 $pers\00314 нет в игре."
			return
		}
	}
	set num [lsearch -exact $hosp(glplayers) $nick]
	if {$num>=0} {
		set hosp(glwhom) [lreplace $hosp(glwhom) $num $num $pers]
	} else {
		set hosp(glwhom) [lappend hosp(glwhom) $pers]
		set hosp(glplayers) [lappend hosp(glplayers) $nick]
	}
	set alr [llength $hosp(glplayers)]
	set alt [expr round ([llength $hosp(gplayers)]/3.0*2)]
	set all [llength $hosp(gplayers)]
	set hosp(qgmax) 0
	set hosp(gmax) ""
	set mes "\00314Статистика: (\00304$alr\00314 :\0034 $all\00314). "
	for {set n 1} {$n<=[llength $hosp(gplayers)]} {incr n} {
		set ch 0
		set wh [lindex $hosp(gplayers) [expr $n-1]]
		foreach val $hosp(glwhom) {
			if {$val==$n} {incr ch}
		}
		if {$hosp(qgmax)<$ch} {
			set hosp(qgmax) $ch
			set hosp(gmax) $n
			set hosp(dobl) 0
		} elseif {$hosp(qgmax)==$ch && $hosp(gmax) != $n} {set hosp(dobl) 1}
		if {$ch>0} {set mes [lappend mes "\00305$wh\00314 -\0033 $ch\00314."]}
	}
#	if {$n==$hosp(gmax)} {set hosp(qgmax) $ch}
	set ch 0
	set n [expr [llength $hosp(gplayers)]+1]
	foreach val $hosp(glwhom) {
		if {$val==$n} {incr ch}
	}
	if {$hosp(qgmax)<=$ch} {
		set hosp(gmax) $n
		set hosp(qgmax) $ch
	}
	if {$ch>0} {set mes [lappend mes "Ночь - $ch."]}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
	putlog "alt - $alt qgmax= $hosp(qgmax)"
#$hosp(qgmax) > $alt || 
	if {$hosp(qgmax) >= $alt || $alr==$all} {
		putserv "PRIVMSG $hosp(chan) :\002\00314Заявки больше не принимаются. Переходим ко второй части."
		set hosp(isgolo1) 0
		hos:killtimers
		utimer 5 hos:golocount
	}
}

proc hos:yes {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgolo2)==0} {return}
	if {![hos:free $nick]} {return}
	if {$nick==$hosp(conf)} {return}
	set x [lsearch -exact $hosp(glplayers) $nick]
	if {$x<0} {
		set hosp(glplayers) [lappend hosp(glplayers) $nick]
		set hosp(glwhom) [lappend hosp(glwhom) "yes"]
	} else {set hosp(glwhom) [lreplace $hosp(glwhom) $x $x "yes"]}
	set yes 0
	set no 0
	foreach val $hosp(glwhom) {
		if {$val=="yes"} {incr yes} else {incr no}	
	}
	set g [llength $hosp(glplayers)]
	set all [expr [llength $hosp(gplayers)]-1]
	set alt [expr round (([llength $hosp(gplayers)]-1)/4.0*3)]
	if {$alt<2} {set alt 2}
	putserv "PRIVMSG $hosp(chan) :\00314Статистика (\0034 $yes \00314-\0034 $no \00314) (\0034 $g \00314-\0034 $all \00314):\0033 $nick\00314 проголосовал \0034за\00314 изолирование\0033 $hosp(conf)\00314."
	if {$yes>=$alt || $g==$all} {
		hos:killtimers
		set hosp(isgolo2) 0
		unbind pubm - "$hosp(chan) !да*" hos:yes
		unbind pubm - "$hosp(chan) !yes*" hos:yes
		unbind pubm - "$hosp(chan) !нет*" hos:no
		unbind pubm - "$hosp(chan) !no*" hos:no
		utimer 1 hos:golo3
	}
}

proc hos:no {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgolo2)==0} {return}
	if {![hos:free $nick]} {return}
	if {$nick==$hosp(conf)} {return}
	set x [lsearch -exact $hosp(glplayers) $nick]
	if {$x<0} {
		set hosp(glplayers) [lappend hosp(glplayers) $nick]
		set hosp(glwhom) [lappend hosp(glwhom) "no"]
	} else {set hosp(glwhom) [lreplace $hosp(glwhom) $x $x "no"]}
	set yes 0
	set no 0
	foreach val $hosp(glwhom) {
		if {$val=="yes"} {incr yes} else {incr no}	
	}
	set g [llength $hosp(glplayers)]
	set all [expr [llength $hosp(gplayers)]-1]
	set alt [expr round (([llength $hosp(gplayers)]-1)/4.0*3)]
	if {$alt<2} {set alt 2}
	putserv "PRIVMSG $hosp(chan) :\00314Статистика (\0034 $yes \00314-\0034 $no \00314) (\0034 $g \00314-\0034 $all \00314):\0033 $nick\00314 проголосовал \0034против\00314 изолирование\0033 $hosp(conf)\00314."
	if {$no>=$alt || $g==$all} {
		hos:killtimers
		set hosp(isgolo2) 0
		unbind pubm - "$hosp(chan) !да*" hos:yes
		unbind pubm - "$hosp(chan) !yes*" hos:yes
		unbind pubm - "$hosp(chan) !нет*" hos:no
		unbind pubm - "$hosp(chan) !no*" hos:no
		utimer 1 hos:golo3
	}
}

proc hos:golo3 {} {
	global hosp
	if {$hosp(madi)==3} {
		set ord [lindex $hosp(wmad) 2]
		set vic [lindex $hosp(wmad) 0]
		set sum [lindex $hosp(wmad) 1]
		if {$vic==$hosp(conf)} {
			hos:frole $hosp(mad) protect
			hos:frole $vic protected
			hos:tablet $hosp(mad) $sum
			hos:tablet $ord [expr -1*$sum]
			putserv "PRIVMSG $hosp(chan) :\002\00314Буйный сорвал голосование."
			utimer 5 hos:count
			return
		}
	}
	set n 0
	set y 0
	foreach val $hosp(glwhom) {
		if {$val=="yes"} {incr y} else {incr n}
	}
	set mes "\00314Оказалось, что изолированный\0033 $hosp(conf)\00314 всего лишь"
	if {$y>$n} {
		set role [hos:getrole $hosp(conf)]
		switch -exact -- $role {
			"main" {
				set mes [lappend mes "\0034главврач\00314."]
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: -50"]
					hos:tablet $hosp(nev) -50
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: -75"]
					hos:tablet $hosp(sis) -75
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val -150
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: -150"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 35
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +35"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +75"]
					hos:tablet $hosp(sym) 75
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +25"]
					hos:tablet $hosp(shiz) 25
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +10"]
					hos:tablet $hosp(nim) 10
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +25"]
					hos:tablet $hosp(mad) 25
				}
			}
			"sis" {
				set mes [lappend mes "\0034медсестра\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: -75"]
					hos:tablet $hosp(main) -75
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: -75"]
					hos:tablet $hosp(nev) -75
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val -200
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: -200"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 50
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +50"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +45"]
					hos:tablet $hosp(sym) 45
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +50"]
					hos:tablet $hosp(shiz) 50
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +1"]
					hos:tablet $hosp(nim) 1
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +15"]
					hos:tablet $hosp(mad) 15
				}
			}
			"nev" {
				set mes [lappend mes "\0034невропатолог\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: -50"]
					hos:tablet $hosp(main) -50
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: -75"]
					hos:tablet $hosp(sis) -75
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val -150
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: -150"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 50
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +50"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +55"]
					hos:tablet $hosp(sym) 55
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +25"]
					hos:tablet $hosp(shiz) 25
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +10"]
					hos:tablet $hosp(nim) 10
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +20"]
					hos:tablet $hosp(mad) 20
				}
			}
			"san" {
				set mes [lappend mes "\0034санитар\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: +30"]
					hos:tablet $hosp(main) 30
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: +30"]
					hos:tablet $hosp(nev) 30
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: +30"]
					hos:tablet $hosp(sis) 30
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 50
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: +50"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val] && $val!=$hosp(conf)} {
						set i 1
						hos:tablet $val -25
					}
				}
				if {$i} {set mes [lappend mes "Санитары: -25"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: -15"]
					hos:tablet $hosp(sym) -15
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +20"]
					hos:tablet $hosp(shiz) 20
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +10"]
					hos:tablet $hosp(nim) 10
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +20"]
					hos:tablet $hosp(mad) 20
				}
			}
			"sym" {
				set mes [lappend mes "\0034симулянт\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: +30"]
					hos:tablet $hosp(main) 30
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: +30"]
					hos:tablet $hosp(nev) 30
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: +30"]
					hos:tablet $hosp(sis) 30
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 75
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: +75"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val -30
					}
				}
				if {$i} {set mes [lappend mes "Санитары: -30"]}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +15"]
					hos:tablet $hosp(shiz) 15
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +7"]
					hos:tablet $hosp(nim) 7
				}
			}
			"shiz" {
				set mes [lappend mes "\0034шизофреник\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: +50"]
					hos:tablet $hosp(main) 50
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: +50"]
					hos:tablet $hosp(nev) 50
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: +15"]
					hos:tablet $hosp(sis) 15
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 60
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: +60"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 30
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +30"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +35"]
					hos:tablet $hosp(sym) 35
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +7"]
					hos:tablet $hosp(nim) 7
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +25"]
					hos:tablet $hosp(mad) 25
				}
			}
			"nim" {
				set mes [lappend mes "\0034нимфоманка\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: +5"]
					hos:tablet $hosp(main) 5
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: +5"]
					hos:tablet $hosp(nev) 5
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 10
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: +10"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 5
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +5"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +10"]
					hos:tablet $hosp(sym) 10
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +5"]
					hos:tablet $hosp(shiz) 5
				}
				if {[hos:free $hosp(mad)]} {
					set mes [lappend mes "Буйный: +5"]
					hos:tablet $hosp(mad) 5
				}
			}
			"psy" {
				set mes [lappend mes "\0034мирный псих\00314."]
				if {[hos:free $hosp(main)]} {
					set mes [lappend mes "Главврач: -35"]
					hos:tablet $hosp(main) -35
				}
				if {[hos:free $hosp(nev)]} {
					set mes [lappend mes "Невропатолог: -35"]
					hos:tablet $hosp(nev) -35
				}
				if {[hos:free $hosp(sis)]} {
					set mes [lappend mes "Медсестра: -25"]
					hos:tablet $hosp(sis) -25
				}
				set i 0
				foreach val $hosp(psy) {
					if {[hos:free $val] && $val!=$hosp(conf)} {
						set i 1
						hos:tablet $val -100
					}
				}
				if {$i} {set mes [lappend mes "Мирные психи: -100"]}
				set i 0
				foreach val $hosp(san) {
					if {[hos:free $val]} {
						set i 1
						hos:tablet $val 5
					}
				}
				if {$i} {set mes [lappend mes "Санитары: +5"]}
				if {[hos:free $hosp(sym)]} {
					set mes [lappend mes "Симулянт: +5"]
					hos:tablet $hosp(sym) 5
				}
				if {[hos:free $hosp(shiz)]} {
					set mes [lappend mes "Шизофреник: +5"]
					hos:tablet $hosp(shiz) 5
				}
				if {[hos:free $hosp(nim)]} {
					set mes [lappend mes "Нимфоманка: +5"]
					hos:tablet $hosp(nim) 5
				}
			}
			"mad" {
				putserv "PRIVMSG $hosp(chan) :\00314Буйный сорвал голосование."
				utimer 5 hos:count
				return
			}
		}
		hos:del $hosp(conf)
#		regsub -all -- {\{} $mes {} mes
#		regsub -all -- {\}} $mes {} mes
		set mes [hos:mes $mes]
		putserv "PRIVMSG $hosp(chan) :$mes."
		hos:frole $hosp(conf) golo
		set i 0
		foreach val $hosp(glplayers) {
			if {[lindex $hosp(glwhom) $i]=="yes"} {hos:frole $val golos}
		}
		utimer 5 hos:count
	} else {
		putserv "PRIVMSG $hosp(chan) :\00314Люди решили все-таки пощадить\0037 $hosp(conf)\00314."
		utimer 5 hos:night
	}
}
