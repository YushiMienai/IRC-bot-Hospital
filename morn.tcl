proc hos:del {nick} {
	global hosp
	set new ""
	if {$hosp(isreg)} {
		foreach val $hosp(players) {
			if {$val != $nick} {set new [lappend new $val]}
		}
		set hosp(players) $new
	} elseif {$hosp(isgame)} {
		foreach val $hosp(gplayers) {
			if {$val != $nick} {set new [lappend new $val]}
		}
		set hosp(gplayers) $new
	}
	if {[onchan $nick $hosp(chan)]} {pushmode $hosp(chan) -v $nick}
}


proc hos:shizzag {} {
	global hosp
	set hosp(numzag) [expr $hosp(numzag)-1]
	if {$hosp(wnim)==$hosp(shiz) && $hosp(wshiz)!=$hosp(nim)} {
		set hosp(wshizi) 0
		return
	}
	if {$hosp(wnim)==$hosp(shiz) && $hosp(wshiz)==$hosp(nim)} {set hosp(nm) 1}
	set val [hos:getrole $hosp(wshiz)]
	hos:del $hosp(wshiz)
	hos:frole $hosp(wshiz) crazied
	hos:frole $hosp(shiz) crazy
	switch -exact -- $val {
		"main" {
			hos:shizzagmain
			hos:tablet $hosp(shiz) 60
		}
		"sis" {
			hos:shizzagsis
			hos:tablet $hosp(shiz) 100
		}
		"nev" {
			hos:shizzagnev
			hos:tablet $hosp(shiz) 60
		}
		"san" {
			hos:shizzagsan
			hos:tablet $hosp(shiz) 50
		}
		"psy" {
			hos:shizzagpsy
			hos:tablet $hosp(shiz) 15
		}
		"sym" {
			hos:shizzagsym
			hos:tablet $hosp(shiz) 35
		}
		"mad" {
			hos:shizzagmad
			hos:tablet $hosp(shiz) 40
		}
		"nim" {
			hos:shizzagnim
			hos:tablet $hosp(shiz) 15
		}
		"shiz" {
			hos:shizzagshiz
			set tab ""
		}
	}
}

proc hos:vrach {} {
	global hosp
	if {$hosp(wnim)==$hosp(main) && $hosp(wmain)!=$hosp(nim)} {return}
	if {$hosp(wnim)==$hosp(main) && $hosp(wmain)==$hosp(nim)} {set hosp(nm) 1}
	if {$hosp(wmaini)==1} {
		if {$hosp(wmain)==$hosp(wsis) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			hos:medmain
			hos:frole $hosp(wsis) helped
			hos:frole $hosp(sis) help
			set tab ""
			set val [hos:getrole $hosp(wsis)]
			switch -exact -- $val {
				"main" {hos:tablet $hosp(sis) 75}
				"sis" {hos:tablet $hosp(sis) 50}
				"psy" {hos:tablet $hosp(sis) 25}
				"nev" {hos:tablet $hosp(sis) 50}
				"san" {hos:tablet $hosp(sis) -15}
				"sym" {hos:tablet $hosp(sis) -15}
				"shiz" {hos:tablet $hosp(sis) -5}
			}
		} else {
			hos:del $hosp(wmain)
			hos:frole $hosp(wmain) isolated
			hos:frole $hosp(main) isolate
			set rol [hos:getrole $hosp(wmain)]
			switch -exact -- $rol {
				"main" {hos:mainizmain}
				"sis" {
					hos:mainizsis 
					hos:tablet $hosp(main) -150
				}
				"psy" {
					hos:mainizpsy
					hos:tablet $hosp(main) -50
				}
				"nev" {
					hos:mainiznev
					hos:tablet $hosp(main) -100
				}
				"san" {
					hos:mainizsan
					hos:tablet $hosp(main) 50
				}
				"sym" {
					hos:mainizsym
					hos:tablet $hosp(main) 60
				}
				"shiz" {
					hos:mainizshiz
					hos:tablet $hosp(main) 70
				}
				"mad" {
					hos:mainizmad
					hos:tablet $hosp(main) 75
				}
				"nim" {
					hos:mainiznim
					hos:tablet $hosp(main) 15
				}
			}
		}
	} elseif {$hosp(wmaini)==2} {
		set res [hos:getrole $hosp(wmain)]
		if {$res=="mad"} {set res "psy"}
		hos:frole $hosp(main) check
		hos:frole $hosp(wmain) checked
		switch -exact -- $res {
			"main" {set mess "$hosp(wmain) - это Главврач"}
			"sis" {set mess "$hosp(wmain) - это Медсестра"}
			"psy" {set mess "$hosp(wmain) - это Мирный псих"}
			"nev" {set mess "$hosp(wmain) - это Невропатолог"}
			"san" {set mess "$hosp(wmain) - это Санитар"}
			"sym" {set mess "$hosp(wmain) - это Симулянт"}
			"shiz" {set mess "$hosp(wmain) - это Шизофреник"}
			"nim" {set mess "$hosp(wmain) - это Нимфоманка"}
		}
		putserv "PRIVMSG $hosp(main) :$mess"
		hos:tablet $hosp(main) 10
		hos:mainch
	}
	if {$hosp(wshiz)==$hosp(wmain) && $hosp(wshizi)==2 && $hosp(wmain)!=$hosp(main)} {
		if {$hosp(wsis)==$hosp(main) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			putserv "PRIVMSG $hosp(chan) :\0032Главврач\00314 чуть не пал жертвой жертвы шизофреника, но был спасен\0032 медсестрой\00314."
			hos:frole $hosp(sis) help
			hos:frole $hosp(main) helped
			hos:tablet $hosp(sis) 75
		} else {
			hos:del $hosp(main)
			hos:frole $hosp(shiz) crazy
			hos:frole $hosp(main) crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\00314Ночью\0032 Главврач\00314 зачем-то неосторожно подошёл к\0033 $hosp(wmain)\00314, не заметив притаившегося рядом\0032 Шизика\00314. Наслушавшись разных антинаучных бредней, он вообразил себя Наполеоном. Пришлось его самого изолировать.\0037 Шизофреник: +25"
		}
	}
}

proc hos:hodnev {} {
	global hosp
	if {$hosp(wnim)==$hosp(nev) && $hosp(wnev)!=$hosp(nim)} {return}
	if {$hosp(wnim)==$hosp(nev) && $hosp(wnev)==$hosp(nim)} {set hosp(nm) 1}
	if {$hosp(wnevi)==1} {
		if {$hosp(wnev)==$hosp(wsis) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(wnim))} {
			hos:mednev
			set val [hos:getrole $hosp(wsis)]
			hos:frole $hosp(wsis) helped
			hos:frole $hosp(sis) help
			switch -exact -- $val {
				"main" {hos:tablet $hosp(sis) 75}
				"sis" {hos:tablet $hosp(sis) 50}
				"psy" {hos:tablet $hosp(sis) 25}
				"nev" {hos:tablet $hosp(sis) 50}
				"san" {hos:tablet $hosp(sis) -15}
				"sym" {hos:tablet $hosp(sis) -15}
				"shiz" {hos:tablet $hosp(sis) -5}
			}
		} else {
			hos:frole $hosp(wnev) isolated
			hos:frole $hosp(nev) isolate
			hos:del $hosp(wnev)
			set val [hos:getrole $hosp(wnev)]
			switch -exact -- $val {
				"nev" {
					hos:neviznev
					hos:tablet $hosp(nev) -150
				}
				"sis" {
					hos:nevizsis
					hos:tablet $hosp(nev) -150
				}
				"psy" {
					hos:nevizpsy
					hos:tablet $hosp(nev) -50
				}
				"nev" {
					hos:neviznev
					hos:tablet $hosp(nev) -100
				}
				"san" {
					hos:nevizsan
					hos:tablet $hosp(nev) 50
				}
				"sym" {
					hos:nevizsym
					hos:tablet $hosp(nev) 60
				}
				"shiz" {
					hos:nevizshiz
					hos:tablet $hosp(nev) 70
				}
				"mad" {
					hos:nevizmad
					hos:tablet $hosp(nev) 75
				}
				"nim" {
					hos:neviznim
					hos:tablet $hosp(nev) 15
				}
			}
		}
	} elseif {$hosp(wnevi)==2} {
		set res [hos:getrole $hosp(wnev)]
		if {$res=="mad"} {set res "psy"}
		hos:frole $hosp(nev) check
		hos:frole $hosp(wnev) checked
		switch -exact -- $res {
			"main" {set mes "$hosp(wnev) - это Главврач"}
			"sis" {set mes "$hosp(wnev) - это Медсестра"}
			"psy" {set mes "$hosp(wnev) - это Мирный псих"}
			"nev" {set mes "$hosp(wnev) - это Невропатолог"}
			"san" {set mes "$hosp(wnev) - это Санитар"}
			"sym" {set mes "$hosp(wnev) - это Симулянт"}
			"shiz" {set mes "$hosp(wnev) - это Шизофреник"}
			"nim" {set mes "$hosp(wnev) - это Нимфоманка"}
		}
		putserv "PRIVMSG $hosp(nev) :$mes"
		putserv "PRIVMSG $hosp(chan) :\0032Невропатолог\00314 нашёл интересные факты в истории болезни\0033 $hosp(wnev)."
		hos:tablet $hosp(nev) 15
	}
	if {$hosp(wshiz)==$hosp(wnev) && $hosp(wshizi)==2 && $hosp(wnev)!=$hosp(nev)} {
		if {$hosp(wsis)==$hosp(nev) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			putserv "PRIVMSG $hosp(chan) :\0032Невропатолог\00314 чуть не пал жертвой жертвы шизофреника, но был спасен\00314 медсестрой."
			hos:frole $hosp(sis) help
			hos:frole $hosp(nev) helped
			hos:tablet $hosp(sis) 50
		} else {
			hos:del $hosp(nev)
			hos:frole $hosp(shiz) crazy
			hos:frole $hosp(nev) crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\0032Невропатолог\0033 $hosp(nev)\00314 сегодня решил заглянуть к\0033 $hosp(wnev)\00314. \0032Шизик\00314 был рад получить очередного собеседника, только вот в здравом уме после таких бесед остаться трудно. \0037Шизик: +25"
		}
	}
}

proc hos:hodsan {} {
	global hosp
	set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
	if {$san == $hosp(wnim) && $hosp(wsan)!=$hosp(nim)} {return}
	if {$hosp(wnim)==$san && $hosp(wsan)==$hosp(nim)} {set hosp(nm) 1}
	if {$hosp(wsan) != $hosp(wsis)} {
		hos:frole $hosp(wsan) beated
		hos:frole $hosp(san) beat
		hos:del $hosp(wsan)
		set val [hos:getrole $hosp(wsan)]
		switch -exact -- $val {
			"main" {
				hos:sanizmain
				hos:tablet $san 45
			}
			"sis" {
				hos:sanizsis
				hos:tablet $san 50
			}
			"nev" {
				hos:saniznev
				hos:tablet $san 40
			}
			"san" {
				hos:sanizsan $san
				if {$san != $hosp(wsan)} {hos:tablet $san -50}
			}
			"psy" {
				hos:sanizpsy
				hos:tablet $san 25
			}
			"sym" {
				hos:sanizsym
				hos:tablet $san -75
			}
			"mad" {
				hos:sanizmad
				hos:tablet $san 55
			}
			"nim" {
				hos:saniznim
				hos:tablet $san 15
			}
			"shiz" {
				hos:sanizshiz
				hos:tablet $san 60
			}
		} 
	} elseif {$hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim)} {
		hos:medsan
		set val [hos:getrole $hosp(wsis)]
		hos:frole $hosp(wsis) helped
		hos:frole $hosp(sis) help
		switch -exact -- $val {
			"main" {hos:tablet $hosp(sis) 75}
			"sis" {hos:tablet $hosp(sis) 50}
			"psy" {hos:tablet $hosp(sis) 25}
			"nev" {hos:tablet $hosp(sis) 50}
			"san" {hos:tablet $hosp(sis) -15}
			"sym" {hos:tablet $hosp(sis) -15}
			"shiz" {hos:tablet $hosp(sis) -5}
		}
	}
	if {$hosp(wsan)==$hosp(wshiz) && $hosp(wshizi)==2 && $hosp(wsan)!=$san} {
		if {$hosp(wsis)==$hosp(san) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			putserv "PRIVMSG $hosp(chan) :\0032Санитар\00314 чуть не пал жертвой жертвы\0032 шизофреника\00314, но был спасен\0032 медсестрой\00314."
			hos:frole $hosp(sis) help
			hos:frole $san helped
			hos:tablet $hosp(sis) -15
		} else {
			hos:del $san
			hos:frole $hosp(shiz) crazy
			hos:frole $san crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\0032Санитар\0033 $san\00314 всю ночь выслеживал\0033 $hosp(wsan)\00314, чтобы набить хорошенько морду, но попал под пагубное влияние\0032 Шизофреника\00314, уже облюбовашего эту жертву.\0037 Шизофреник: +25"
		}
	}
}

proc hos:hodshiz {} {
	global hosp
	if {($hosp(wshizi)==1)} {
		if {$hosp(shiz) == $hosp(wnim) && $hosp(wshiz)!=$hosp(nim)} {return}
		if {$hosp(wnim)==$hosp(shiz) && $hosp(wshiz)==$hosp(nim)} {set hosp(nm) 1}
		if {$hosp(wshiz)==$hosp(wsis)} {
			hos:frole $hosp(wsis) helped
			hos:frole $hosp(sis) help
			set val [hos:getrole $hosp(wsis)]
			switch -exact -- $val {
				"main" {hos:tablet $hosp(sis) 75}
				"sis" {hos:tablet $hosp(sis) 50}
				"psy" {hos:tablet $hosp(sis) 25}
				"nev" {hos:tablet $hosp(sis) 50}
				"san" {hos:tablet $hosp(sis) -15}
				"sym" {hos:tablet $hosp(sis) -15}
				"shiz" {hos:tablet $hosp(sis) -5}
			}
			hos:medshiz
		} else {
			hos:del $hosp(wshiz)
			hos:frole $hosp(wshiz) isolated
			hos:frole $hosp(shiz) isolate
			set val [hos:getrole $hosp(wshiz)]
			switch -exact -- $val {
				"main" {
					hos:shizizmain
					hos:tablet $hosp(shiz) 60
				}
				"sis" {
					hos:shizizsis
					hos:tablet $hosp(shiz) 100
				}
				"psy" {
					hos:shizizpsy
					hos:tablet $hosp(shiz) 15
				}
				"nev" {
					hos:shiziznev
					hos:tablet $hosp(shiz) 60
				}
				"san" {
					hos:shizizsan
					hos:tablet $hosp(shiz) 50
				}
				"sym" {
					hos:shizizsym
					hos:tablet $hosp(shiz) 35
				}
				"nim" {
					hos:shiziznim
					hos:tablet $hosp(shiz) 15
				}
				"mad" {
					hos:shizizmad
					hos:tablet $hosp(shiz) 40
				}
				"shiz" {hos:shizizshiz}
			}
		}
	}
}

proc hos:hodmad {} {
	global hosp
	set ord [lindex $hosp(wmad) 2]
	set vic [lindex $hosp(wmad) 0]
	set sum [lindex $hosp(wmad) 1]
	if {$hosp(mad) == $hosp(wnim) && $vic!=$hosp(nim)} {
		set hosp(wmad) ""
		set hosp(madi) 0
		return
	}
	if {$hosp(wnim)==$hosp(mad) && $vic==$hosp(nim)} {set hosp(nm) 1}
	if {$hosp(madi)==1} {
		if {$vic==$hosp(wsis)} {
			set val [hos:getrole $hosp(wsis)]
			switch -exact -- $val {
				"main" {hos:tablet $hosp(sis) 75}
				"sis" {hos:tablet $hosp(sis) 50}
				"psy" {hos:tablet $hosp(sis) 25}
				"nev" {hos:tablet $hosp(sis) 50}
				"san" {hos:tablet $hosp(sis) -15}
				"sym" {hos:tablet $hosp(sis) -15}
				"shiz" {hos:tablet $hosp(sis) -5}
			}
			hos:frole $hosp(sis) help
			hos:frole $hosp(wsis) helped
			hos:medmad
		} else {
			hos:tablet $hosp(mad) $sum
			hos:frole $vic beated
			hos:frole $hosp(mad) beat
			hos:tablet $ord [expr -1*$sum]
			hos:del $vic
			set val [hos:getrole $vic]
			switch -exact -- $val {
				"main" {hos:madizmain $vic $sum}
				"sis" {hos:madizsis $vic $sum}
				"psy" {hos:madizpsy $vic $sum}
				"nev" {hos:madiznev $vic $sum}
				"san" {hos:madizsan $vic $sum}
				"sym" {hos:madizsym $vic $sum}
				"nim" {hos:madiznim $vic $sum}
				"mad" {hos:madizmad $vic $sum}
				"shiz" {hos:madizshiz $vic $sum}
			}
		}
	}
	if {$hosp(madi)==2} {
		hos:frole $vic checked
		hos:tablet $hosp(mad) $sum
		set summ [expr -1*$sum]
		hos:tablet $ord $summ
		hos:frole $hosp(mad) check
		set nim [hos:getrole $vic]
		if {$nim=="mad"} {set nim "psy"}
		switch -exact -- $nim {
			"main" {set mes "\0033$vic\00314 - это \0032главврач\00314"}
			"sis" {set mes "\0033$vic\00314 - это \0032медсестра\00314"}
			"nev" {set mes "\0033$vic\00314 - это \0032невропатолог\00314"}
			"san" {set mes "\0033$vic\00314 - это \0032санитар\00314"}
			"psy" {set mes "\0033$vic\00314 - это \0032мирный псих\00314"}
			"shiz" {set mes "\0033$vic\00314 - это \0023шизофреник\00314"}
			"sym" {set mes "\0033$vic\00314 - это \0032симулянт\00314"}
			"nim" {set mes "\0033$vic\00314 - это \0032нимфоманка\00314"}
		}
		putserv "PRIVMSG $hosp(chan) :\0032Буйный\00314 ночью копался в бухгалтерии и выяснил, что $mes."
	}
	if {$hosp(wmad)==$hosp(wshiz) && $hosp(wshizi)==2 && $hosp(wmad)!=$hosp(mad)} {
		if {$hosp(wsis)==$hosp(mad) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			putserv "PRIVMSG $hosp(chan) :\0032Буйный\00314 чуть не пал жертвой жертвы шизофреника, но был спасен\0032 медсестрой\00314."
			hos:frole $hosp(sis) help
			hos:frole $hosp(mad) helped
		} else {
			hos:del $hosp(mad)
			hos:frole $hosp(shiz) crazy
			hos:frole $hosp(mad) crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\0032Буйный\0033 $hosp(mad)\00314 не знал, что его жертва была под воздействием безумства\0032 шизофреника\00314. Шизофреник: +25"
		}
	}
}

proc hod:hodsym {} {
	global hosp
	if {$hosp(sym) == $hosp(wnim) && $hosp(wsym)!=$hosp(nim)} {return}
	if {$hosp(wnim)==$hosp(sym) && $hosp(wsym)==$hosp(nim)} {set hosp(nm) 1}
	hos:frole $hosp(sym) check
	hos:frole $hosp(wsym) checked
	set res [hos:getrole $hosp(wsym)]
	if {$res=="mad"} {set res "psy"}
	switch -exact -- $res {
		"main" {set mes "$hosp(wsym) - это Главврач"}
		"sis" {set mes "$hosp(wsym) - это Медсестра"}
		"psy" {set mes "$hosp(wsym) - это Мирный псих"}
		"nev" {set mes "$hosp(wsym) - это Невропатолог"}
		"san" {set mes "$hosp(wsym) - это Санитар"}
		"sym" {set mes "$hosp(wsym) - это Симулянт"}
		"shiz" {set mes "$hosp(wsym) - это Шизофреник"}
		"nim" {set mes "$hosp(wsym) - это Нимфоманка"}
	}
	putserv "PRIVMSG $hosp(sym) :$mes"
	putserv "PRIVMSG $hosp(chan) :Просмотрев несколько личных дел больных, \00313симулянт\003 узнал, кто такой $hosp(wsym)."
	hos:tablet $hosp(sym) 20
	if {$hosp(wsym)==$hosp(wshiz) && $hosp(wshizi)==2 && $hosp(wsym)!=$hosp(sym)} {
		if {$hosp(wsis)==$hosp(wsym) && ($hosp(sis)!=$hosp(wnim) || $hosp(wsis)==$hosp(nim))} {
			putserv "PRIVMSG $hosp(chan) :\0032Симулянт\00314 чуть не пал жертвой жертвы шизофреника, но был спасен\0032 медсестрой\00314."
			hos:frole $hosp(sis) help
			hos:frole $hosp(sym) helped
			hos:tablet $hosp(sis) -15
		} else {
			hos:del $hosp(sym)
			hos:frole $hosp(shiz) crazy
			hos:frole $hosp(sym) crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\0032Симулянт\0033 $hosp(sym)\00314 пытался выяснить, кто такой\0033 $hosp(wsym), но крутившийся рядом\0032 Шизофреник\00314 доканал и его.\0037 Шизофреник: +25"
		}
	}
}

proc hos:hodnim {} {
	global hosp
	if {$hosp(nm)} {return}
	hos:frole $hosp(nim) tempt
	hos:frole $hosp(wnim) tempted
	set nim [hos:getrole $hosp(wnim)]
	switch -exact -- $nim {
		"main" {
			hos:nimmain
			hos:tablet $hosp(nim) 55
			hos:tablet $hosp(wnim) -55
		}
		"sis" {
			hos:nimsis
			hos:tablet $hosp(nim) 35
			hos:tablet $hosp(wnim) -35
		}
		"psy" {
			hos:nimpsy
			hos:tablet $hosp(nim) 25
			hos:tablet $hosp(wnim) -25
		}
		"nev" {
			hos:nimnev
			hos:tablet $hosp(nim) 50
			hos:tablet $hosp(wnim) -50
		}
		"san" {
			hos:nimsan
			hos:tablet $hosp(nim) 45
			hos:tablet $hosp(wnim) -45
		}
		"sym" {
			hos:nimsym
			hos:tablet $hosp(nim) 40
			hos:tablet $hosp(wnim) -40
		}
		"shiz" {
			hos:nimshiz
			hos:tablet $hosp(nim) 35
			hos:tablet $hosp(wnim) -35
		}
		"mad" {
			hos:nimmad
			hos:tablet $hosp(nim) 30
			hos:tablet $hosp(wnim) -30
		}
		"nim" {hos:nimnim}
	}
	if {$hosp(wnim)==$hosp(wshiz) && $hosp(wshizi)==2 && $hosp(wnim)!=$hosp(nim)} {
		if {$hosp(wsis)==$hosp(nim)} {
			putserv "PRIVMSG $hosp(chan) :\0032Нимфоманка\00314 чуть не пала жертвой жертвы шизофреника, но был спасен\0032 медсестрой\00314."
			hos:frole $hosp(sis) help
			hos:frole $hosp(nim) helped
		} else {
			hos:del $hosp(nim)
			hos:frole $hosp(shiz) crazy
			hos:frole $hosp(nim) crazied
			hos:tablet $hosp(shiz) 25
			putserv "PRIVMSG $hosp(chan) :\0032Нимфоманка\0033 $hosp(nim)\00314 ночью заходила к\0033 $hosp(wnim)\00314, а оказалось, что там проходило чаепитие с\0032 Шизофреником\00314.\0037 Шизофреник: +25"
		}
	}
}

proc hos:morn {} {
	global hosp
	hos:kick
	set hosp(nm) 0
	set hosp(night) 0
	set hosp(morn) 1
	putserv "PRIVMSG $hosp(chan) :\00314Наступило утро. Не у всех есть возможность спокойно отдохнуть после бессонной ночи - в приёмном покое уже ждёт бригада реаниматологов."
	if {$hosp(wsis) == "" && [hos:free $hosp(sis)]} {
		hos:del $hosp(sis)
		putserv "PRIVMSG $hosp(chan) :\00314Длина халата\0032 Медсестры\0033 $hosp(sis)\00314 очень не понравилась проверяющим из министерства. Придётся ей теперь искать другую работу."
	}
	#Если шизофреник заговорил жертву
	if {$hosp(wshizi)==2} {hos:shizzag} elseif {$hosp(wshiz)=="" && [hos:free $hosp(shiz)]} {
		hos:del $hosp(shiz)
		putserv "PRIVMSG $hosp(chan) :\00314Пока\0032 Шизофреник\0033 $hosp(shiz)\00314 ушёл в себя, его всей толпой быстренько упаковали в смирительную рубашку и заперли с глаз долой в карантинном боксе."
	}
	#Ход главврача
	if {$hosp(wmain)!=""} {hos:vrach} elseif {[hos:free $hosp(main)]} {
		hos:del $hosp(main)
		putserv "PRIVMSG $hosp(chan) :\0032Главврач\0033 $hosp(main)\00314 попался на глаза министру здравоохранеиния в пьяном виде и лишился диплома!"
	}
	#Ход невропатолога
	if {$hosp(wnev)!=""} {hos:hodnev}  elseif {[hos:free $hosp(nev)]} {
		hos:del $hosp(nev)
		putserv "PRIVMSG $hosp(chan) :\0032Невропатолог\0033 $hosp(nev)\00314 не прошёл аттестацию и был уволен без выходного пособия."
	}
	#Ход санитара
	set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
	if {$hosp(wsan)!=""} {hos:hodsan}  elseif {[hos:free $san]} {
		hos:del $san
		putserv "PRIVMSG $hosp(chan) :\0032Санитар\0033 $san\00314 ушёл в запой и опустился морально окончательно. Теперь он БОМЖ и в больницу его больше не пускают."
	}
	#Ход шизофреника (если просто изоляция)
	if {$hosp(wshiz)!="" && $hosp(wshizi)==1} {hos:hodshiz} elseif {$hosp(wshiz)=="" && [hos:free $hosp(shiz)]} {
		hos:del $hosp(shiz)
		putserv "PRIVMSG $hosp(chan) :\00314Пока\0032 Шизофреник\0033 $hosp(shiz)\00314 ушёл в себя, его всей толпой быстренько упаковали в смирительную рубашку и заперли с глаз долой в карантинном боксе."
	}
	#Ход симулянта
	if {$hosp(wsym) != ""} {hos:hodsym} elseif {[hos:free $hosp(sym)]} {
		hos:del $hosp(sym)
		putserv "PRIVMSG $hosp(chan) :\0032Симулянт\0032 $hosp(sym)\00314 не успел спрятаться от комиссии, присланной из военкомата."
	}
	#Ход буйного
	if {$hosp(wmad) != ""} {hos:hodmad} elseif {[hos:free $hosp(mad)] && $hosp(madiz)=="" && $hosp(madch)=="" && $hosp(madpr)==""} {
		hos:del $hosp(mad)
		putserv "PRIVMSG $hosp(chan) :\0032Буйный\0033 $hosp(mad)\00314 слишком долго думал."
	}
	#Ход нимфоманки
	if {$hosp(wnim) != ""} {hos:hodnim} elseif {[hos:free $hosp(nim)]} {
		hos:del $hosp(nim)
		putserv "PRIVMSG $hosp(chan) :\0032Нимфоманка\0033 $hosp(nim)\00314 слишком долго думала, но так и не смогла выбрать себе партнера на ночь."
	}
	if {$hosp(wsis)==$hosp(wshiz) && $hosp(shiz)==2 && $hosp(wsis)!=$hosp(sis) && ($hosp(wsis)==$hosp(nim) || $hosp(wnim) != $hosp(sis))} {
		hos:del $hosp(sis)
		hos:tablet $hosp(shiz) 75
		putserv "PRIVMSG $hosp(chan) :\0032Медсестра\0033 $hosp(sis)\00314 хотела как-то помочь\0033 $hosp(wsis)\00314, но ошивавшийся рядом\0032 Шизик\00314 нёс такую околесицу, что прибывший в больницу утром наряд милиции не глядя запер на 15 суток всю компанию.\0037 Шизофреник: +75"
	}
	foreach val $hosp(gplayers) {
		set role [hos:getrole $val]
		switch -exact -- $role {
			"main" {hos:tablet $val 15}
			"sis" {hos:tablet $val 20}
			"nev" {hos:tablet $val 15}
			"san" {hos:tablet $val 20}
			"psy" {hos:tablet $val 5}
			"mad" {hos:tablet $val 15}
			"shiz" {hos:tablet $val 20}
			"sym" {hos:tablet $val 25}
			"nim" {hos:tablet $val 35}
		}
	}
	set mes "\00310Выжившие получают таблеток:"
	set i 0
	foreach val $hosp(psy) {
		if {[hos:free $val]} {set i 1}
	}
	if {$i} {set mes [lappend mes "Мирные психи\0037 +5\00310"]}
	if {[hos:free $hosp(main)]} {set mes [lappend mes "Главврач\0037 +15\00310"]}
	if {[hos:free $hosp(sis)]} {set mes [lappend mes "Медсестра\0037 +20\00310"]}
	if {[hos:free $hosp(nev)]} {set mes [lappend mes "Невропатолог\0037 +15\00310"]}
	set i 0
	foreach val $hosp(san) {
		if {[hos:free $val]} {set i 1}
	}
	if {$i} {set mes [lappend mes "Санитары\0037 +20\00310"]}
	if {[hos:free $hosp(shiz)]} {set mes [lappend mes "Шизофреник\0037 +20\00310"]}
	if {[hos:free $hosp(sym)]} {set mes [lappend mes "Симулянт\0037 +25\00310"]}
	if {[hos:free $hosp(nim)]} {set mes [lappend mes "Нимфоманка\0037 +35\00310"]}
	if {[hos:free $hosp(mad)]} {set mes [lappend mes "Буйный\0037 +25\00310"]}
	regsub -all -- {\{} $mes {} mes
	regsub -all -- {\}} $mes {} mes
	putserv "PRIVMSG $hosp(chan) :$mes"
	set ns 1
	set q 1
	while {$ns} {
		incr hosp(qsan)
		if {$hosp(qsan)>[llength $hosp(san)]} {set hosp(qsan) 1}
		set san [lindex $hosp(san) [expr $hosp(qsan)-1]]
		if {[hos:free $san]} {set ns 0}
		if {$q>[llength $hosp(san)]} {set ns 0}
		incr q
	}
	utimer 5 hos:count
	set hosp(wshizi) 0
	set hosp(wnim) ""
	set hosp(wmain) ""
	set hosp(wsis) ""
	set hosp(wsan) ""
	set hosp(wsym) ""
	set hosp(wmad) ""
	set hosp(wnev) ""
	set hosp(wshiz) ""
	set hosp(wmaini) 0
	set hosp(wnevi) 0
	set hosp(wshizi) 0
	set hosp(madiz) ""
	set hosp(wmadiz) ""
	set hosp(smadiz) ""
	set hosp(madch) ""
	set hosp(wmadch) ""
	set hosp(smadch) ""
	set hosp(madpr) ""
	set hosp(wmadpr) ""
	set hosp(smadpr) ""
}

proc hos:grask {} {
	global hosp
	bind 
	putserv "PRIVMSG $hosp(chan) :Шизоид $hosp(shiz) решил раскаяться. !<да/yes> или !<нет/no>"
	utimer
}

proc hos:team {nick} {
	global hosp
	set t [hos:getrole $nick]
	switch -exact -- $t {
		"main" {return "good"}
		"sis" {return "good"}
		"nev" {return "good"}
		"san" {return "bad"}
		"psy" {return "good"}
		"mad" {return "neu"}
		"shiz" {return "shiz"}
		"sym" {return "bad"}
		"nim" {return "neu"}
	}
}

proc hos:levk {nick} {
	global hosp
	set t [hos:getrole $nick]
	switch -exact -- $t {
		"main" {return 1}
		"sis" {return 0}
		"nev" {return 1}
		"san" {return 1}
		"psy" {return 0}
		"mad" {return 0}
		"shiz" {return 1}
		"sym" {return 0}
		"nim" {return 0}
	}
}

proc hos:count {} {
	global hosp
#	putserv "PRIVMSG $hosp(chan) :День..."
	set qua [llength $hosp(gplayers)]
	switch -exact -- $qua {
		"0" {
			putserv "PRIVMSG $hosp(chan) :\00314Никто не выиграл."
			utimer 10 hos:win
		}
		"1" {
			putserv "PRIVMSG $hosp(chan) :\00314Победа\0033 $hosp(gplayers)\00314. Приз -\0037 50\00314 таблеток."
			hos:tablet $hosp(gplayers) 50
			hos:frole $hosp(gplayers) win
			utimer 10 hos:win
		}
		"2" {
			set g 0
			foreach val $hosp(gplayers) {
				if {[hos:team $val]=="good"} {incr g}
				if {[hos:team $val]=="bad"} {set g [expr $g-1]}
			}
			if {$g=="2"} {
				putserv "PRIVMSG $hosp(chan) :\00314Добро победило! Выжившим по\0037 50\00314 таблеток!"
				foreach val $hosp(gplayers) {
					hos:frole $val win
					hos:tablet $val 50
				}
			} elseif {$g == "-2"} {
				putserv "PRIVMSG $hosp(chan) :\00314Зло победило! Выжившим по\0037 50\00314 таблеток!"
				foreach val $hosp(gplayers) {
					hos:frole $val win
					hos:tablet $val 50
				}
			} else {
				set lev1 [lindex $hosp(gplayers) 0]
				set lev2 [lindex $hosp(gplayers) 1]
				set lev1 [hos:levk $lev1]
				set lev2 [hos:levk $lev2]
				if {$lev1 && $lev2} {
					putserv "PRIVMSG $hosp(chan) :\002\00314Ничья! Выжившие получают бонус - по\0037 25\00314 таблеток!"
					hos:tablet [lindex $hosp(gplayers) 0] 25
					hos:tablet [lindex $hosp(gplayers) 1] 25
				} elseif {$lev1>$lev2} {
					set win [lindex $hosp(gplayers) 0]
					putserv "PRIVMSG $hosp(chan) :\002\00314Победа\0033 $win\00314! Приз\0037 50\00314 таблеток."
					hos:frole $win win
					hos:tablet $win 50
				} elseif {$lev1<$lev2} {
					set win [lindex $hosp(gplayers) 1]
					putserv "PRIVMSG $hosp(chan) :\002\00314Победа\0033 $win\00314! Приз\0037 50\00314 таблеток."
					hos:frole $win win
					hos:tablet $win 50
				} else {
					set n 0
					foreach val $hosp(gplayers) {
						if {[hos:team $val]=="neu"} {incr n}
					}
					if {$n>0 && $g>0} {
						putserv "PRIVMSG $hosp(chan) :\002\00314Добро победило! Выжившим по\0037 50\00314 таблеток!"
						foreach val $hosp(gplayers) {
							if {[hos:team $val]=="good"} {
								hos:frole $val win
								hos:tablet $val 50
							}
						}
					} elseif {$n>0 && $g<0} {
						putserv "PRIVMSG $hosp(chan) :\002\00314Зло победило! Выжившим по\0037 50\00314 таблеток!"
						foreach val $hosp(gplayers) {
							if {[hos:team $val]=="bad"} {
								hos:frole $val win
								hos:tablet $val 50
							}
						}
					} elseif {$n>0 && $g==0} {
						putserv "PRIVMSG $hosp(chan) :\002\00314Победила дружба! Выжившим по\0037 50\00314 таблеток!"
						foreach val $hosp(gplayers) {
							hos:frole $val win
							hos:tablet $val 50
						}
					} else {
						putserv "PRIVMSG $hosp(chan) :\002\00314Ничья! Выжившим по\0037 25\00314 таблеток!"
						foreach val $hosp(gplayers) {hos:tablet $val 25}
					}
				}
			}
			utimer 10 hos:win
		}
		default {
			set g 0
			set b 0
			set s 0
			set gm 0
			set bm 0
			set nm 0
			foreach val $hosp(gplayers) {
				if {[hos:levk $val]} {
					if {[hos:team $val]=="good"} {incr g}
					if {[hos:team $val]=="bad"} {incr b}
					if {[hos:team $val]=="shiz"} {incr s}
				} else {
					if {[hos:team $val]=="good"} {incr gm}
					if {[hos:team $val]=="bad"} {incr bm}
					if {[hos:team $val]=="neu"} {incr nm}
				}
			}
			if {($g>0 && $b>0) || ($s>0 && $b>0) || ($g>0 && $s>0) || ($b>0 && $g==0 && [expr $b+$bm]<[expr $gm+$nm+$s]) || ($b==0 && $g>0 && [expr $g+$gm]<[expr $bm+$nm+$s])} {
				if {$hosp(morn)} {utimer 10 hos:golo} else {utimer 10 hos:night}
			} else {
				if {$g>0 || ($g==0 && $b==0 && $bm>$gm && $hosp(rask))} {
					putserv "PRIVMSG $hosp(chan) :\002\00314Добро победило! Выжившим по\0037 50\00314 таблеток!"
					foreach val $hosp(gplayers) {
						if {[hos:team $val]=="good"} {
							hos:frole $val win
							hos:tablet $val 50
						}
					}
				} elseif {$b>0 || ($g==0 && $b==0 && $bm<$gm && $hosp(rask))} {
					putserv "PRIVMSG $hosp(chan) :\002\00314Зло победило! Выжившим по\0037 50\00314 таблеток!"
					foreach val $hosp(gplayers) {
						if {[hos:team $val]=="bad"} {
							hos:frole $val win
							hos:tablet $val 50
						}
					}
				} elseif {$bm==$gm} {
					putserv "PRIVMSG $hosp(chan) :\002\00314Ничья! Выжившим по\0037 25\00314 таблеток!"
					foreach val $hosp(gplayers) {hos:tablet $val 25}
				} else {
					putserv "PRIVMSG $hosp(chan) :002\00314Победила дружба! Выжившим по\0037 50\00314 таблеток!"
					foreach val $hosp(gplayers) {
						hos:frole $val win
						hos:tablet $val 50
					}
				}
				utimer 10 hos:win
			}
		}
	}
}

proc hos:nagr {nick} {
	global hosp
	set fid [open $hosp(tmpfile) r]
	while {![eof $fid]} {
		gets $fid usline
		if {$nick==[lindex $usline 0]} {set res [lindex $usline 1]}
	}
	close $fid
	return $res
}

proc hos:win {} {
	global hosp
	set hosp(night) 0
	set hosp(isgolo2) 0
	foreach val $hosp(gplayers) {hos:del $val}
	pushmode $hosp(chan) -m
	putserv "PRIVMSG $hosp(chan) :\002\00314В ролях:"
	set tab [hos:nagr $hosp(main)]
	putserv "PRIVMSG $hosp(chan) :\0032Главврач\00314:\0033 $hosp(main)\00314 -\0037 $tab\00314"
	set tab [hos:nagr $hosp(sis)]
	putserv "PRIVMSG $hosp(chan) :\0032Медсестра\00314:\0033 $hosp(sis)\00314 -\0037 $tab\00314"
	set mes "\0032Санитары:\00314:\0033"
	foreach val $hosp(san) {
		set tab [hos:nagr $val]
		set mes [lappend mes " $val \00314 -\0037 $tab\00314."]
	}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
	if {$hosp(numshiz)>0} {
		set tab [hos:nagr $hosp(shiz)]
		putserv "PRIVMSG $hosp(chan) :\0032Шизофреник\00314:\0033 $hosp(shiz)\00314 -\0037 $tab\00314"
	}
	if {$hosp(numnev)>0} {
		set tab [hos:nagr $hosp(nev)]
		putserv "PRIVMSG $hosp(chan) :\0032Невропатолог\00314:\0033 $hosp(nev)\00314 -\0037 $tab\00314"
	}
	if {$hosp(numsym)>0} {
		set tab [hos:nagr $hosp(sym)]
		putserv "PRIVMSG $hosp(chan) :\0032Симулянт\00314:\0033 $hosp(sym)\00314 -\0037 $tab\00314"
	}
	if {$hosp(numnim)>0} {
		set tab [hos:nagr $hosp(nim)]
		putserv "PRIVMSG $hosp(chan) :\0032Нимфоманка\00314:\0033 $hosp(nim)\00314 -\0037 $tab\00314"
	}
	if {$hosp(nummad)>0} {
		set tab [hos:nagr $hosp(mad)]
		putserv "PRIVMSG $hosp(chan) :\0032Буйный\00314:\0033 $hosp(mad)\00314 -\0037 $tab\00314"
	}
	set mes "\0032Мирные психи:\00314:"
	foreach val $hosp(psy) {
		set tab [hos:nagr $val]
		set mes [lappend mes "\0033 $val \00314 -\0037 $tab\00314."]
	}
#	regsub -all -- {\{} $mes {} mes
#	regsub -all -- {\}} $mes {} mes
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
	hos:savestats
	hos:end
}

proc hos:end {} {
	global hosp
	set hosp(isgame) 0
	set hosp(night) 0
	set hosp(isreg) 0
	set hosp(isgolo1) 0
	set hosp(isgolo2) 0
	set hosp(noch) 0
	set hosp(players) "" 
	set hosp(gplayers) "" 
	set hosp(psy) ""
	set hosp(main) "" 
	set hosp(sis) ""
	set hosp(nev) ""
	set hosp(san) ""
	set hosp(sym) ""
	set hosp(shiz) ""
	set hosp(nim) ""
	set hosp(mad) ""
	set hosp(numpsy) 0
	set hosp(nummain) 0 
	set hosp(numsis) 0
	set hosp(numnev) 0
	set hosp(numsan) 0
	set hosp(numsym) 0
	set hosp(numshiz) 0
	set hosp(numnim) 0
	set hosp(nummad) 0
	set hosp(wnim) ""
	set hosp(wmain) ""
	set hosp(wsis) ""
	set hosp(wsan) ""
	set hosp(wsym) ""
	set hosp(wmad) ""
	set hosp(wnev) ""
	set hosp(wshiz) ""
	set hosp(wmaini) 0
	set hosp(wnevi) 0
	set hosp(qsan) 0
	set hosp(wshizi) 0
	set hosp(madiz) ""
	set hosp(wmadiz) ""
	set hosp(smadiz) ""
	set hosp(madch) ""
	set hosp(wmadch) ""
	set hosp(smadch) ""
	set hosp(madpr) ""
	set hosp(wmadpr) ""
	set hosp(smadpr) ""
	set hosp(all) 0
	set hosp(rask) 0
	set hosp(glplayers) ""
	set hosp(glwhom) ""
	set hosp(conf) 0
	set hosp(gmax) ""
	hos:killtimers
}
