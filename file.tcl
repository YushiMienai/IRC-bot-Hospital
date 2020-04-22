proc hos:frole {nick role} {
	global hosp
	file copy -force $hosp(tmpfile) $hosp(tmpfile).bkp
	set instr [open $hosp(tmpfile).bkp r]
	set outstr [open $hosp(tmpfile) w+]
	while {![eof $instr]} {
		gets $instr usline
		if {[lindex $usline 0]==$nick} {
			switch -exact -- $role {
				"psy" {set usline [lreplace $usline 2 2 $role]}
				"main" {set usline [lreplace $usline 2 2 $role]}
				"sis" {set usline [lreplace $usline 2 2 $role]}
				"nev" {set usline [lreplace $usline 2 2 $role]}
				"nim" {set usline [lreplace $usline 2 2 $role]}
				"mad" {set usline [lreplace $usline 2 2 $role]}
				"san" {set usline [lreplace $usline 2 2 $role]}
				"sym" {set usline [lreplace $usline 2 2 $role]}
				"shiz" {set usline [lreplace $usline 2 2 $role]}
				"check" {set usline [lreplace $usline 3 3 [expr [lindex $usline 3]+1]]}
				"isolate" {set usline [lreplace $usline 4 4 [expr [lindex $usline 4]+1]]}
				"beat" {set usline [lreplace $usline 5 5 [expr [lindex $usline 5]+1]]}
				"tempt" {set usline [lreplace $usline 6 6 [expr [lindex $usline 6]+1]]}
				"help" {set usline [lreplace $usline 7 7 [expr [lindex $usline 7]+1]]}
				"protect" {set usline [lreplace $usline 8 8 [expr [lindex $usline 8]+1]]}
				"crazy" {set usline [lreplace $usline 9 9 [expr [lindex $usline 9]+1]]}
				"repent" {set usline [lreplace $usline 10 10 [expr [lindex $usline 10]+1]]}
				"checked" {set usline [lreplace $usline 11 11 [expr [lindex $usline 11]+1]]}
				"isolated" {set usline [lreplace $usline 12 12 [expr [lindex $usline 12]+1]]}
				"beated" {set usline [lreplace $usline 13 13 [expr [lindex $usline 13]+1]]}
				"tempted" {set usline [lreplace $usline 14 14 [expr [lindex $usline 14]+1]]}
				"helped" {set usline [lreplace $usline 15 15 [expr [lindex $usline 15]+1]]}
				"protected" {set usline [lreplace $usline 16 16 [expr [lindex $usline 16]+1]]}
				"crazied" {set usline [lreplace $usline 17 17 [expr [lindex $usline 17]+1]]}
				"golo" {set usline [lreplace $usline 18 18 [expr [lindex $usline 18]+1]]}
				"win" {set usline [lreplace $usline 19 19 [expr [lindex $usline 19]+1]]}
				"golos" {set usline [lreplace $usline 20 20 [expr [lindex $usline 20]+1]]}
				default {set usline [lreplace $usline 1 1 $role]}
			}
		}
		puts $outstr $usline
	}
	close $outstr
	close $instr
}

proc hos:tablet {nick summ} {
	global hosp
	set s1 0
	set instr [open $hosp(tmpfile) r]
	while {![eof $instr]} {
		gets $instr usline
		if {[lindex $usline 0]==$nick} {
			set s1 [lindex $usline 1]
		}
	}
	close $instr
	set res [expr $s1+$summ]
	hos:frole $nick $res
	
	if {[hos:getrole $nick]=="san" && $summ==-45} {return}
	if {[hos:getrole $nick]=="san"} {
		foreach val $hosp(san) {
			if {$val != $nick && [hos:free $val]} {
				set instr [open $hosp(tmpfile) r]
				while {![eof $instr]} {
					gets $instr usline
					if {[lindex $usline 0]==$nick} {
						set s1 [lindex $usline 1]
					}
				}
				set res [expr $s1+$summ]
				hos:frole $val $res
			}
		}
	}
}

proc hos:isplayed {nick} {
	global hosp
	if {![file exists $hosp(plfile)]} {return 0}
	set fid [open $hosp(plfile) r]
	while {![eof $fid]} {
		gets $fid usline
		if {[lindex $usline 0] == $nick} {
			close $fid
			return 1
		}
	}
	close $fid	
	return 0
}

proc hos:statget {nick type} {
#	putlog "statget"
	global hosp
	set res 0
	set fid [open $hosp(plfile) r]
	while {![eof $fid]} {
		gets $fid usline
		if {[lindex $usline 0]==$nick} {
			switch -exact -- $type {
				"tab" {set res [lindex $usline 1]}
				"games" {set res [lindex $usline 2]}
				"psy" {set res [lindex $usline 3]}
				"main" {set res [lindex $usline 4]}
				"sis" {set res [lindex $usline 5]}
				"san" {set res [lindex $usline 6]}
				"nev" {set res [lindex $usline 7]}
				"nim" {set res [lindex $usline 8]}
				"shiz" {set res [lindex $usline 9]}
				"mad" {set res [lindex $usline 10]}
				"sym" {set res [lindex $usline 11]}
				"check" {set res [lindex $usline 12]}
				"isolate" {set res [lindex $usline 13]}
				"beat" {set res [lindex $usline 14]}
				"tempt" {set res [lindex $usline 15]}
				"help" {set res [lindex $usline 16]}
				"protect" {set res [lindex $usline 17]}
				"crazy" {set res [lindex $usline 18]}
				"repent" {set res [lindex $usline 19]}
				"checked" {set res [lindex $usline 20]}
				"isolated" {set res [lindex $usline 21]}
				"beated" {set res [lindex $usline 22]}
				"tempted" {set res [lindex $usline 23]}
				"helped" {set res [lindex $usline 24]}
				"protected" {set res [lindex $usline 25]}
				"crazied" {set res [lindex $usline 26]}
				"golo" {set res [lindex $usline 27]}
				"win" {set res [lindex $usline 28]}
				"best" {set res [lindex $usline 29]}
				"golos" {set res [lindex $usline 30]}
			}
		}
	}
	close $fid
	return $res
}

proc hos:savestats {} {
	global hosp
	set fid [open $hosp(tmpfile) r]
	while {![eof $fid]} {
		set psy 0
		set main 0
		set sis 0
		set nev 0
		set san 0
		set sym 0
		set shiz 0
		set nim 0
		set mad 0
		set games 1
		gets $fid usline
		if {$usline==""} {
			continue
		}
		set nick [lindex $usline 0]
		set tab [expr [hos:statget $nick tab]+[lindex $usline 1]]
		set currole [lindex $usline 2]
		switch -exact -- $currole {
			"psy" {set psy 1}
			"main" {set main 1}
			"sis" {set sis 1}
			"sym" {set sym 1}
			"san" {set san 1}
			"nim" {set nim 1}
			"mad" {set mad 1}
			"shiz" {set shiz 1}
			"nev" {set nev 1}
		}
		set psy [expr [hos:statget $nick psy]+$psy]
		set main [expr [hos:statget $nick main]+$main]
		set sis [expr [hos:statget $nick sis]+$sis]
		set nev [expr [hos:statget $nick nev]+$nev]
		set san [expr [hos:statget $nick san]+$san]
		set sym [expr [hos:statget $nick sym]+$sym]
		set nim [expr [hos:statget $nick nim]+$nim]
		set shiz [expr [hos:statget $nick shiz]+$shiz]
		set mad [expr [hos:statget $nick mad]+$mad]
		set check [expr [hos:statget $nick check]+[lindex $usline 3]]
		set isolate [expr [hos:statget $nick isolate]+[lindex $usline 4]]
		set beat [expr [hos:statget $nick beat]+[lindex $usline 5]]
		set tempt [expr [hos:statget $nick tempt]+[lindex $usline 6]]
		set help [expr [hos:statget $nick help]+[lindex $usline 7]]
		set protect [expr [hos:statget $nick protect]+[lindex $usline 8]]
		set crazy [expr [hos:statget $nick crazy]+[lindex $usline 9]]
		set repent [expr [hos:statget $nick repent]+[lindex $usline 10]]
		set checked [expr [hos:statget $nick checked]+[lindex $usline 11]]
		set isolated [expr [hos:statget $nick isolated]+[lindex $usline 12]]
		set beated [expr [hos:statget $nick beated]+[lindex $usline 13]]
		set tempted [expr [hos:statget $nick tempted]+[lindex $usline 14]]
		set helped [expr [hos:statget $nick helped]+[lindex $usline 15]]
		set protected [expr [hos:statget $nick protected]+[lindex $usline 16]]
		set crazied [expr [hos:statget $nick crazied]+[lindex $usline 17]]
		set golo [expr [hos:statget $nick golo]+[lindex $usline 18]]
		set win [expr [hos:statget $nick win]+[lindex $usline 19]]
		set games [expr [hos:statget $nick games]+$games]
		if {[hos:statget $nick best]<[lindex $usline 1]} {set best [lindex $usline 1]} else {set best [hos:statget $nick best]}
		set golos [expr [hos:statget $nick golos]+[lindex $usline 20]]
		set stats "$nick $tab $games $psy $main $sis $san $nev $nim $shiz $mad $sym $check $isolate $beat $tempt $help $protect $crazy $repent $checked $isolated $beated $tempted $helped $protected $crazied $golo $win $best $golos"

		if {[hos:isplayed $nick]} {
			file copy -force $hosp(plfile) $hosp(plfile).bkp
			set instr [open $hosp(plfile).bkp r]
			set outstr [open $hosp(plfile) w+]
			while {![eof $instr]} {
				gets $instr points
				if {$points==""} {
					break
				}
				if {$nick == [lindex $points 0]} {
					set points $stats
				}
				puts $outstr $points
			}
			close $instr
			close $outstr
		} else {
			set instr [open $hosp(plfile) a]
			puts $instr $stats
			close $instr
		}
	}
	close $fid
}

proc hos:mesto {nick} {
	global hosp
	set tab ""
	set rang 0
	set fid [open $hosp(plfile) r]
	while {![eof $fid]} {
		gets $fid usline
		set tab [lappend tab [lindex $usline 1]]
	}
	close $fid
	regsub -all -- {\{} $tab {} tab
	regsub -all -- {\}} $tab {} tab
	set tab [lsort -unique $tab]
	set tab [lsort -integer -decreasing $tab]
	for {set i 0} {$i<[llength $tab]} {incr i} {
		set fid [open $hosp(plfile) r]
		while {![eof $fid]} {
			gets $fid stats
			if {$nick==[lindex $stats 0] && [lindex $tab $i]==[lindex $stats 1]} {set rang [expr $i+1]}
		}
		close $fid
	}
	return $rang
}

proc hos:ispersn {arg} {
	global hosp
	set fid [open $hosp(plfile) r]
	set res $arg
#	set i 1
	while {![eof $fid]} {
		gets $fid usline
		set p [lindex $usline 0]
		set p [hos:mesto $p]
		if {$p==$arg} {
			set res [lindex $usline 0]
			break
		}
#		incr i
	}
	close $fid
	return $res
}


proc hos:pwon {nick uhost handle chan text} {
	global hosp
	if {$hosp(chan)!=$chan} {return}
	set who [lindex $text 1]
	if {$who==""} {set who $nick} elseif {$who!=""} {set who [hos:ispersn $who]}
#	if {$who==""} {[lindex $text 1]}
	if {![hos:isplayed $who]} {
		putserv "PRIVMSG $hosp(chan) :\002\00314Человек по имени\0033 $who\00314 пока не сыграл ни в одной игре.\003"
		return
	}
	set tab [hos:statget $who tab]
	set games [hos:statget $who games]
	set win [hos:statget $who win]
	set best [hos:statget $who best]
	set rang [hos:mesto $who]
	set mid [expr round ( $tab / $games )]
	putserv "PRIVMSG $hosp(chan) :\00314Статистика\0033 $who\00314: Таблеток всего:\0037 $tab\00314, Таблеток в среднем:\0037 $mid\00314, Самое большее за игру:\0037 $best\00314, Место:\0034 $rang\00314, Кол-во игр:\00310 $games\00314, Кол-во побед:\0037 $win\003"
}

proc hos:mwon {nick uhost handle text} {
	global hosp
	set who [lindex $text 1]
	if {$who==""} {set who $nick}
	if {![hos:isplayed $who]} {
		putserv "PRIVMSG $nick :\002\00314Человек по имени\0033 $who\00314 пока не сыграл ни в одной игре.\003"
		return
	}
	set tab [hos:statget $who tab]
	set games [hos:statget $who games]
	set win [hos:statget $who win]
	set best [hos:statget $who best]
	set rang [hos:mesto $who]
	set mid [expr round ( $tab / $games )]
	putserv "PRIVMSG $nick :\00314Статистика\0033 $who\00314: Таблеток всего:\0037 $tab\00314, Таблеток в среднем:\0037 $mid\00314, Самое большее за игру:\0037 $best\00314, Место:\0034 $rang\00314, Кол-во игр:\00310 $games\00314, Кол-во побед:\0037 $win\003"
}

proc hos:top {} {
	global hosp
	set best ""
	set fid [open $hosp(plfile) r]
	while {![eof $fid]} {
		gets $fid usline
		set tab [lappend tab [lindex $usline 1]]
	}
	close $fid
	set tab [hos:mes $tab]
	set tab [lsort -unique $tab]
	set tab [lsort -integer -decreasing $tab]
	if {[llength $tab]>10} {set t 10} else {set t [llength $tab]}
	set mes "\00314Первые\0035 $t\00314 мест:\0036"
	for {set i 0} {$i<$t} {incr i} {
		set fid [open $hosp(plfile) r]
		while {![eof $fid]} {
			gets $fid stats
			if {[lindex $tab $i]==[lindex $stats 1]} {
				set n [expr $i+1]
				set name [lindex $stats 0]
				set zar [lindex $tab $i]
				set mes [lappend mes "$n\00314.\0033 $name\00314 -\0037 $zar\00314.\0036"]
			}
		}
		close $fid
	}
	set mes [hos:mes $mes]
	return $mes
}

proc hos:ptop {nick uhost handle chan text} {
	global hosp
	set mes [hos:top]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mtop {nick uhost handle text} {
	global hosp
	set mes [hos:top]
	putserv "PRIVMSG $nick :$mes"
}


proc hos:pfullwon {nick uhost handle chan text} {
	global hosp
	if {$hosp(chan)!=$chan} {return}
	set who [lindex $text 1]
	if {$who==""} {set who $nick} elseif {$who!=""} {set who [hos:ispersn $who]}
	if {![hos:isplayed $who]} {
		putserv "PRIVMSG $hosp(chan) :\002\00314Человек по имени\0033 $who\00314 пока не сыграл ни в одной игре.\003"
		return
	}
	set tab [hos:statget $who tab]
	set games [hos:statget $who games]
	set win [hos:statget $who win]
	set best [hos:statget $who best]
	set rang [hos:mesto $who]
	set mid [expr round ( $tab / $games )]
	putserv "PRIVMSG $chan :\00314Статистика\0033 $who\00314: Таблеток всего:\0037 $tab\00314, Таблеток в среднем:\0037 $mid\00314, Самое большее за игру:\0037 $best\00314, Место:\0034 $rang\00314, Кол-во игр:\00310 $games\00314, Кол-во побед:\0037 $win\003"
	set psy [hos:statget $who psy]
	set main [hos:statget $who main]
	set sis [hos:statget $who sis]
	set san [hos:statget $who san]
	set nim [hos:statget $who nim]
	set nev [hos:statget $who sis]
	set shiz [hos:statget $who shiz]
	set mad [hos:statget $who mad]
	set sym [hos:statget $who sym]
	putserv "PRIVMSG $chan :\00314Роли\0033 $who\00314: Мирный псих -\0035 $psy\00314, Главврач -\0035 $main\00314, Медсестра -\0035 $sis\00314, Санитар -\0035 $san\00314, Шизофреник -\0035 $shiz\00314, Симулянт -\0035 $sym\00314, Нимфоманка -\0035 $nim\00314, Буйный -\0035 $mad\00314."
	set check [hos:statget $who check]
	set isolate [hos:statget $who isolate]
	set help [hos:statget $who help]
	set beat [hos:statget $who beat]
	set crazy [hos:statget $who crazy]
	set tempt [hos:statget $who tempt]
	set protect [hos:statget $who protect]
	set golos [hos:statget $who golos]
	putserv "PRIVMSG $chan :\00314Статистика действий\0033 $who\00314: Проверял -\0035 $check\00314, Изолировал -\0035 $isolate\00314, Спасал -\0035 $help\00314, Избивал -\0035 $beat\00314, Заговаривал -\0035 $crazy\00314, Соблазнял -\0035 $tempt\00314, Защищал -\0035 $protect\00314, Изолировал по голосованию -\0035 $golos\00314."
	set checked [hos:statget $who checked]
	set isolated [hos:statget $who isolated]
	set helped [hos:statget $who helped]
	set beated [hos:statget $who beated]
	set crazied [hos:statget $who crazied]
	set tempted [hos:statget $who tempted]
	set protected [hos:statget $who protected]
	set golo [hos:statget $who golo]
	putserv "PRIVMSG $chan :\00314Статистика воздействий\0033 $who\00314: Проверялся -\0035 $checked\00314, Изолировался -\0035 $isolated\00314, Спасался -\0035 $helped\00314, Избивался -\0035 $beated\00314, Заговаривался -\0035 $crazied\00314, Соблазнялся -\0035 $tempted\00314, Защищался -\0035 $protected\00314, Изолировался по голосованияю -\0035 $golo\00314."
}

proc hos:mfullwon {nick uhost handle text} {
	global hosp
	set who [lindex $text 1]
	if {$who==""} {set who $nick} elseif {$who!=""} {set who [hos:ispersn $who]}
	if {![hos:isplayed $who]} {
		putserv "PRIVMSG $hosp(chan) :\002\00314Человек по имени\0033 $who\00314 пока не сыграл ни в одной игре.\003"
		return
	}
	set tab [hos:statget $who tab]
	set games [hos:statget $who games]
	set win [hos:statget $who win]
	set best [hos:statget $who best]
	set rang [hos:mesto $who]
	set mid [expr round ( $tab / $games )]
	putserv "PRIVMSG $nick :\00314Статистика\0033 $who\00314: Таблеток всего:\0037 $tab\00314, Таблеток в среднем:\0037 $mid\00314, Самое большее за игру:\0037 $best\00314, Место:\0034 $rang\00314, Кол-во игр:\00310 $games\00314, Кол-во побед:\0037 $win\003"
	set psy [hos:statget $who psy]
	set main [hos:statget $who main]
	set sis [hos:statget $who sis]
	set san [hos:statget $who san]
	set nim [hos:statget $who nim]
	set nev [hos:statget $who sis]
	set shiz [hos:statget $who shiz]
	set mad [hos:statget $who mad]
	set sym [hos:statget $who sym]
	putserv "PRIVMSG $nick :\00314Роли\0033 $who\00314: Мирный псих -\0035 $psy\00314, Главврач -\0035 $main\00314, Медсестра -\0035 $sis\00314, Санитар -\0035 $san\00314, Шизофреник -\0035 $shiz\00314, Симулянт -\0035 $sym\00314, Нимфоманка -\0035 $nim\00314, Буйный -\0035 $mad\00314."
	set check [hos:statget $who check]
	set isolate [hos:statget $who isolate]
	set help [hos:statget $who help]
	set beat [hos:statget $who beat]
	set crazy [hos:statget $who crazy]
	set tempt [hos:statget $who tempt]
	set protect [hos:statget $who protect]
	set golos [hos:statget $who golos]
	putserv "PRIVMSG $nick :\00314Статистика действий\0033 $who\00314: Проверял -\0035 $check\00314, Изолировал -\0035 $isolate\00314, Спасал -\0035 $help\00314, Избивал -\0035 $beat\00314, Заговаривал -\0035 $crazy\00314, Соблазнял -\0035 $tempt\00314, Защищал -\0035 $protect\00314, Изолировал по голосованию -\0035 $golos\00314."
	set checked [hos:statget $who checked]
	set isolated [hos:statget $who isolated]
	set helped [hos:statget $who helped]
	set beated [hos:statget $who beated]
	set crazied [hos:statget $who crazied]
	set tempted [hos:statget $who tempted]
	set protected [hos:statget $who protected]
	set golo [hos:statget $who golo]
	putserv "PRIVMSG $nick :\00314Статистика воздействий\0033 $who\00314: Проверялся -\0035 $checked\00314, Изолировался -\0035 $isolated\00314, Спасался -\0035 $helped\00314, Избивался -\0035 $beated\00314, Заговаривался -\0035 $crazied\00314, Соблазнялся -\0035 $tempted\00314, Защищался -\0035 $protected\00314, Изолировался по голосованияю -\0035 $golo\00314."
}

proc hos:topbest {} {
	global hosp
	set best ""
	set fid [open $hosp(plfile) r]
	while {![eof $fid]} {
		gets $fid usline
		set best [lappend best [lindex $usline 29]]
	}
	close $fid
	set best [hos:mes $best]
	set best [lsort -unique $best]
	set best [lsort -integer -decreasing $best]
	if {[llength $best]>10} {set t 10} else {set t [llength $best]}
	set mes "\00314Первые\0035 $t\00314 мест:\0036"
	for {set i 0} {$i<$t} {incr i} {
		set fid [open $hosp(plfile) r]
		while {![eof $fid]} {
			gets $fid stats
			if {[lindex $best $i]==[lindex $stats 29]} {
				set n [expr $i+1]
				set name [lindex $stats 0]
				set zar [lindex $stats 29]
				set mes [lappend mes "$n\00314.\0033 $name\00314 -\0037 $zar\00314.\0036"]
			}
		}
		close $fid
	}
	set mes [hos:mes $mes]
	return $mes
}

proc hos:ptopbest {nick uhost handle chan text} {
	global hosp
	set mes [hos:topbest]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mtopbest {nick uhost handle text} {
	global hosp
	set mes [hos:topbest]
	putserv "PRIVMSG $nick :$mes"
	putserv "PRIVMSG $nick :test"
}
