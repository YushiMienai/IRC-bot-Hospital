#Функция !старт
proc hos:begin {nick uhost handle chan text} {
	global hosp
	if { $chan != $hosp(chan) } {return}
	#Если игра уже началась
	if {$hosp(isgame)==1} {return}
	#Если игра остановленна командой hult
	if {$hosp(ishulted)==1} {
		if {[hos:getinfo level $nick]>0} { 
			putserv "PRIVMSG $chan :\002\00314Бот запущен."
			set hosp(ishulted) 0
		} else {
			putserv "PRIVMSG $chan :\002\00314Бот остановлен командой \0037!hult\00314. Для запуска бота надо быть минимум полуоператором."
			return
		}
	}
	putserv "PRIVMSG $chan :\002\00314Началась регистрация. Для регистрации введите \0037!рег\00314 или \0037!куп\00314 или \0037!reg\00314 или \0037!htu\00314. Регистрация будет проходить 3 минуты."
	set hosp(isgame) 1
	set hosp(isreg) 1
	set hosp(numpl) 0
	set hosp(all) 0
	set hosp(night) 0
	set hosp(isgolo1) 1
	set hosp(gmax) ""
	set hosp(qgmax) 0
	set hosp(dobl) 0
	set hosp(conf) 0
	#Роли
	set hosrop(psy) ""
	set hosrop(main) "" 
	set hosrop(sis) ""
	set hosrop(nev) ""
	set hosrop(san) ""
	set hosrop(sym) ""
	set hosrop(shiz) ""
	set hosrop(nim) ""
	set hosrop(mad) ""
	set hosp(players) ""
	set hosp(numpsy) 0
	set hosp(nummain) 0 
	set hosp(numsis) 0
	set hosp(numnev) 0
	set hosp(numsan) 0
	set hosp(numsym) 0
	set hosp(numshiz) 0
	set hosp(numnim) 0
	set hosp(nummad) 0
	utimer 120 hos:reg2
}

#Функция !рег
proc hos:reg {nick uhost handle chan text} {
	global hosp
	if { $chan != $hosp(chan) } {return}
	if { $hosp(ishulted) == 1 } {
		if {[hos:getinfo level $nick]>0} {
			hos:begin $nick $uhost $handle $chan $text
		} else {
			putserv "PRIVMSG $chan :\002\00314Бот остановлен командой \0037!hult\00314. Для запуска бота надо быть минимум полуоператором."
			return
		}
	}
	if {$hosp(isgame)==0} {hos:begin $nick $uhost $handle $chan $text}
	if {$hosp(isreg)==0} {return}
	if {([hos:isregister $nick])&&(![hos:isidentify $nick])} {
		putserv "PRIVMSG $chan :\002\00314Ник \0037$nick\00314 зарегистрирован в базе. Чтобы зарегистрироваться в игре надо набрать мне в приват \0037!identify\00314."
		return
	}
	if {[hos:isingame $nick]} {return}
#	if {[isop $nick $chan]} {pushmode $chan -o $nick}
	pushmode $chan +v $nick
	set hosp(players) [lappend hosp(players) $nick]
}

proc hos:reg2 {} {
	global hosp
	putserv "PRIVMSG $hosp(chan) :\00314Внимание! До конца регистрации осталось одна минута. Для регистрации введите \0037!рег\00314 или \0037!куп\00314 или \0037!reg\00314 или \0037!htu\00314."
	utimer 60 hos:endreg
	}	

proc hos:endreg {} {
	global hosp
	set new ""
	foreach val $hosp(players) {
		if {[onchan $val $hosp(chan)]} {set new [lappend new $val]}
	}
	set hosp(players) $new
	if {[llength $hosp(players)]<4} {
		foreach val $hosp(players) {
			if {[onchan $val $hosp(chan)]} {pushmode $hosp(chan) -v $val}
		}
		set hosp(players) ""
		putserv "PRIVMSG $hosp(chan) :\00314Слишком мало народу. Больница сегодня не откроется."
		set hosp(isgame) 0
		set hosp(isreg) 0
		foreach val $hosp(players) {
			if {[onchan $val $hosp(chan)]} {pushmode $hosp(chan) -v $val}
		}
		set hosp(players) ""
		hos:end
		return
	}
	putserv "MODE $hosp(chan) +m"
	set hosp(isreg) 0
	putserv "PRIVMSG $hosp(chan) :\002\00314Регистрация закончилась. Переходим к раздаче ролей."
	set hosp(gplayers) $hosp(players)
	set fid [open $hosp(tmpfile) w]
	foreach val $hosp(players) {
#Ник зароботок роль (статистика) проверял изолировал избивал соблазнял помогал защищал заговаривал раскаивался проверялся изолировался соблазнялся помогался защищался заговаривался вешался
		puts $fid "$val 0 none 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
	}
	close $fid
	hos:setroles
}

proc hos:join {nick uhost hand chan args} {
	global botnick hosp
	if {$chan!=$hosp(chan)} {return}
	if {$nick==$botnick} {
		set hosp(isgame) 0
		set hosp(isreg) 0
		hos:killtimers
		set hosp(players) ""
		return
	}
#	if {$hosp(isgame)==0 || $hosp(isreg)==1} {putserv "PRIVMSG $chan :\00314Приветствую вас на канале игры 'Психбольница'.\0036 Доступные команды будут перечисленны вам в приват, по команде \0035!<команды/commands>\0036 (в приват боту)"}
	if {[hos:isingame $nick]} {
		if {[hos:isregister $nick]} {
			putserv "PRIVMSG $hosp(chan) :\00314Ник \0037$nick\00314 зарегестрирован, для возвращения в игру вам надо идентифицировать его."
		} else {
#			if {[isop $nick $chan]} {pushmode $chan -o $nick}
			pushmode $chan +v $nick
			return
		}
	}
}

proc hos:splt {nick uhost hand chan args} {
	global hosp
	if {[hos:isingame $nick]} {
		if {[hos:isregister $nick]} {
			putserv "PRIVMSG $hosp(chan) :\002\00314Ник \0037$nick\00314 зарегестрирован, для возвращения в игру вам надо идентифицировать его."
		} else {
#			if {[isop $nick $chan]} {pushmode $chan -o $nick}
			pushmode $chan +v $nick
			return
		}
	}
}

proc hos:mode {n uh h c m v} {
	global hosp botnick
	if {$c!=$hosp(chan)} {return}
	if {$hosp(isgame)==0} {return}
	if {($v==$botnick)&&($m=="-o")} {
		putserv  "PRIVMSG $hosp(chan) :\002\00314Бот был лишен опа и игра не может быть продолжена."
		hos:end
		return
	}
	if {([hos:isingame $v])&&($m=="-v")} {pushmode $hosp(chan) +v $v}
	if {(![hos:isingame $v])&&($m=="+v")} {pushmode $hosp(chan) -v $v}
#	if {([hos:isingame $v])&&($m=="+o")} {pushmode $hosp(chan) -o $v}
}

proc hos:opendreg {nick uhost hand chan args} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {![hos:isidentify $nick]} {return}
	if {[hos:getinfo level $nick]<1} {return}
	hos:killtimers
	hos:endreg
}

proc hos:kick {} {
	global hosp
	foreach val $hosp(gplayers) {
		if {![onchan $val $hosp(chan)]} {
			hos:del $val
			set role [hos:getrole $val]
			switch -exact -- $role {
				main {putserv "PRIVMSG $hosp(chan) :\002\0032Главврач\0033 $val\00314 вышел и уже не успеет вернуться."}
				sis {putserv "PRIVMSG $hosp(chan) :\002\0032Медсестра\0033 $val\00314 вышла и уже не успеет вернуться."}
				nev {putserv "PRIVMSG $hosp(chan) :\002\0032Невропатолог\0033 $val\00314 вышел и уже не успеет вернуться."}
				san {putserv "PRIVMSG $hosp(chan) :\002\0032Санитар\0033 $val\00314 вышел и уже не успеет вернуться."}
				psy {putserv "PRIVMSG $hosp(chan) :\002\0032Мирный псих\0033 $val\00314 вышел и уже не успеет вернуться."}
				shiz {putserv "PRIVMSG $hosp(chan) :\002\0032Шизофреник\0033 $val\00314 вышел и уже не успеет вернуться."}
				mad {putserv "PRIVMSG $hosp(chan) :\002\0032Буйный\0033 $val\00314 вышел и уже не успеет вернуться."}
				nim {putserv "PRIVMSG $hosp(chan) :\002\0032Нимфоманка\0033 $val\00314 вышла и уже не успеет вернуться."}
				sym {putserv "PRIVMSG $hosp(chan) :\002\0032Симулянт\0033 $val\00314 вышел и уже не успеет вернуться."}
			}
#			putserv "PRIVMSG $hosp(chan) :\002\0032$role\0033 $val\00314 вышел и уже не успеет вернуться."
		}
	}
	foreach val $hosp(unr) {hos:del $val}
	set hosp(unr) ""
}

proc hos:unreg {nick uhost hand chan args} {
	global hosp
	if {$hosp(isreg)} {hos:del $nick} elseif {$hosp(isgame)} {
		if {![hos:isingame $nick]} {
			set hosp(unr) [lappend hosp(unp) $nick]
			pushmode $hosp(chan) -v $v
		}
	}
}
