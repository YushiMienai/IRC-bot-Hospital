proc hos:isregister {nick} {
	global hosp
	if {![file exists $hosp(regus)]} {
		return 0
	}
	set fid [open $hosp(regus) r]
	while {![eof $fid]} {
		gets $fid usline
		if {[lindex $usline 0]==$nick} {

			return 1
		}
	}
	close $fid	
	return 0
}


proc hos:register {nick uhost handle text} {
	global hosp
	
	if {[lindex $text 1]!=""} {
		set pass [lindex $text 1]
	} else {
		putserv "PRIVMSG $nick :Надо ввести пароль."
		return
	}
	if {![hos:isregister $nick]} {
		if {![file exists $hosp(regus)]} {
			set fid [open $hosp(regus) w]
		} else { set fid [open $hosp(regus) a]}
		puts $fid "$nick $pass $uhost 0"
		close $fid
		putserv "PRIVMSG $nick :Ник \0037$nick\003 теперь зареген. Пароль - \0037$pass\003."
		putlog "Зареген $nick"
	} else {
		putserv "PRIVMSG $nick :Ник \0037$nick\003 уже занят."
	}
}

proc hos:isidentify {nick} {
	global hosp
	if {$hosp(regnicks)==""} { return 0 }
	foreach value $hosp(regnicks) {
		if {$value == $nick} {return 1}
#		putserv "PRIVMSG $nick :Ник \0037$value\003"
	}
	return 0
}

proc hos:identify {nick uhost handle text} {
	global hosp
	if {[lindex $text 1]!=""} {
		set pass [lindex $text 1]
	} else {
		putserv "PRIVMSG $nick :Надо ввести пароль."
		return
	}
	if {![hos:isregister $nick]} {
		putserv "PRIVMSG $nick :Ник \0037$nick\003 не зарегестрирован."
		return
	}
	if {[hos:isidentify $nick]} {
		putserv "PRIVMSG $nick :Ник \0037$nick\003 уже идентефицирован."
		return
	}
	set fid [open $hosp(regus) r]
	while {![eof $fid]} {
		gets $fid usline
		if {[lindex $usline 0]==$nick} {
			set pas1 [lindex $usline 1]
			set pas2 [lindex $text 1]
			if {$pas1 == $pas2} {
				set hosp(regnicks) [lappend hosp(regnicks) $nick]
				close $fid
				putserv "PRIVMSG $nick :Ник \0037$nick\003 успешно идентефицирован."
				if {[hos:isingame $nick]} {
#					if {[isop $nick $chan]} {pushmode $chan -o $nick}
					pushmode $hosp(chan) +v $nick
				}
				return
			}
			putserv "PRIVMSG $nick :Неверный пароль."
		}
	}
	close $fid	
}

proc hos:getinfo {type nick} {
	global hosp
	if {![hos:isregister $nick]} {
#		putserv "PRIVMSG $hosp(chan) :Ник \0037$nick\003 не зарегестрирован (для регистрации введите \0037!register\003 мне в приват)."
		return 0
	}
	if {![hos:isidentify $nick]} {
#		putserv "PRIVMSG $hosp(chan) :Ник \0037$nick\003 не идентифицирован (для идентификации введите \0037!identify\003 мне в приват)."
		return 0
	}
	set fid [open $hosp(regus) r]
	while {![eof $fid]} {
		gets $fid usline
		if {[lindex $usline 0]==$nick} {
		close $fid
			switch -exact -- $type {
				"level" {return [lindex $usline 3]}
				"pass" {return [lindex $usline 1]}
				default {return 0}
			}
		}
	}
}

proc hos:isingame {nick} {
	global hosp
	if {$hosp(isreg)} {
		foreach val $hosp(players) {
			if {$val == $nick} {
				return 1
			}
		}
	} else {
		foreach val $hosp(gplayers) {
			if {$val == $nick} {
				return 1
			}
		}
	}
	return 0
}

proc hos:unidentify {nick} {
	global hosp
	set new ""
	foreach val $hosp(regnicks) {
		if {$val != $nick} {set new [lappend new $nick]}
	}
	set hosp(regnicks) $new
}


proc hos:part {nick uhost hand chan args} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {[hos:isidentify $nick]} {
		hos:unidentify $nick
		putserv "PRIVMSG $nick :Ник \0037$nick\003 больше не является идентифицированным."
	}
}

proc hos:nick {nick uhost handle chan newnick} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	hos:unidentify $nick
	if {[hos:isidentify $nick]} {
		hos:unidentify $nick
		putserv "PRIVMSG $newnick :Ник \0037$nick\003 больше не является идентифицированным."
	}
	if {$hosp(isgame)==0} {return}
	if {[hos:isingame $nick]} {
		pushmode $hosp(chan) -v $newnick
		putserv "PRIVMSG $chan :Все, а в особенности ты, \0037$newnick\003, менять ник во время регистрации и игры запрещено."
		return
	}
	if {[hos:isingame $newnick] && ![hos:isregister $newnick]} {
		pushmode $hosp(chan) +v $newnick
		putserv "PRIVMSG $chan :Пациент \0037$newnick\003, снова с нами."
		return
	}
}



proc hos:setinfo {type nick arg} {
	global hosp
	if {![hos:isregister $nick]} {return}
	file copy -force $hosp(regus) $hosp(regus).bkp
	set instr [open $hosp(regus).bkp r]
	set outstr [open $hosp(regus) w+]
	while {![eof $instr]} {
		gets $instr usline
		if {[lindex $usline 0]==$nick} {
			switch -exact -- $type {
				"level" {set usline [lreplace $usline 3 3 $arg]}
				"pass" {set usline [lreplace $usline 1 1 $arg]}
			}
		}
		puts $outstr $usline
	}
	close $outstr
	close $instr
}

proc hos:chlev {nick uhost handle text} {
	global hosp
	if {![hos:isidentify $nick]} {return}
	set vic [lindex $text 1]
	set arg [lindex $text 2]
	if {[hos:getinfo level $vic]>=[hos:getinfo level $nick]} {return}
	hos:setinfo level $vic $arg
}
