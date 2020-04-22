bind pubm - "$hosp(chan) !start*" hos:begin
bind pubm - "$hosp(chan) !старт*" hos:begin
bind join - "$hosp(chan) *" hos:join
bind splt - "$hosp(chan) *" hos:splt
bind mode - "$hosp(chan) *" hos:mode
bind part - "$hosp(chan) *" hos:part
bind nick - "$hosp(chan) *" hos:nick
bind msgm - "!commands*" hos:coms
bind msgm - "!команды*" hos:coms
bind msgm - "!help*" hos:help
bind msgm - "!хелп*" hos:help
bind msgm - "!помощь*" hos:help
bind msgm - "!описание*" hos:desc
bind msgm - "!desc*" hos:desc

#Регистрация в игре
bind pubm - "$hosp(chan) !htu*" hos:reg
bind pubm - "$hosp(chan) !reg*" hos:reg
bind pubm - "$hosp(chan) !куп*" hos:reg
bind pubm - "$hosp(chan) !рег*" hos:reg
bind pubm - "$hosp(chan) !анрег*" hos:unreg
bind pubm - "$hosp(chan) !unreg*" hos:unreg
bind msgm - "!список*" hos:mlist
bind pubm - "$hosp(chan) !список*" hos:plist
bind msgm - "!list*" hos:mlist
bind pubm - "$hosp(chan) !list*" hos:plist
bind msgm - "!роли*" hos:mroles
bind pubm - "$hosp(chan) !роли*" hos:proles
bind msgm - "!roles*" hos:mroles
bind pubm - "$hosp(chan) !roles*" hos:proles
bind msgm - "!ходы*" hos:mturns
bind pubm - "$hosp(chan) !ходы*" hos:pturns
bind msgm - "!turns*" hos:mturns
bind pubm - "$hosp(chan) !turns*" hos:pturns


#Команды операторов
bind pubm - "$hosp(chan) !o*" hos:po
bind msgm - "!o*" hos:mo
bind pubm - "$hosp(chan) !do*" hos:pdo
bind msgm - "!do*" hos:mdo
bind msgm - "!chlev*" hos:chlev
bind pubm - "$hosp(chan) !endreg*" hos:opendreg
bind pubm - "$hosp(chan) !ендрег*" hos:opendreg
bind pubm - "$hosp(chan) !эндрег*" hos:opendreg
bind pubm - "$hosp(chan) !утв*" hos:opendreg
bind pubm - "$hosp(chan) !halt*" hos:phult
bind pubm - "$hosp(chan) !халт*" hos:phult
bind pubm - "!halt*" hos:mhult
bind pubm - "!халт*" hos:mhult
bind pubm - "$hosp(chan) !kick*" hos:pkick
bind msgm - "!kick*" hos:mkick
bind pubm - "$hosp(chan) !дальше*" hos:pfurther
bind msgm - "!дальше*" hos:mfurther
bind pubm - "$hosp(chan) !further*" hos:pfurther
bind msgm - "!further*" hos:mfurther
bind msgm - "!голо2*" hos:nn
bind msgm - "!rehash*" hos:rehash
bind msgm - "!restart*" hos:restart
bind msgm - "!joinchan*" hos:jchan
bind msgm - "!partchan*" hos:pchan
bind msgm - "!asay*" hos:asay
bind msgm - "!act*" hos:act
bind msgm - "!barchan*" hos:barchan

#Регистрация у бота
bind msgm - "!register*" hos:register
bind msgm - "!identify*" hos:identify


#Рекорды
bind pubm - "$hosp(chan) !вон*" hos:pwon
bind pubm - "$hosp(chan) !won*" hos:pwon
bind msgm - "!вон*" hos:mwon
bind msgm - "!won*" hos:mwon
bind pubm - "$hosp(chan) !top*" hos:ptop
bind pubm - "$hosp(chan) !топ*" hos:ptop
bind pubm - "$hosp(chan) !лучшие*" hos:ptop
bind msgm - "!top*" hos:mtop
bind msgm - "!топ*" hos:mtop
bind msgm - "!лучшие*" hos:mtop
bind pubm - "$hosp(chan) !фулвон*" hos:pfullwon
bind pubm - "$hosp(chan) !fullwon*" hos:pfullwon
bind pubm - "!фулвон*" hos:sfullwon
bind msgm - "!фулвон*" hos:mfullwon
bind msgm - "!fullwon*" hos:mfullwon
bind pubm - "$hosp(chan) !tabbest*" hos:ptopbest
bind msgm - "!tabbest*" hos:mtopbest
bind pubm - "$hosp(chan) !макс*" hos:ptopbest
bind msgm - "!макс*" hos:mtopbest


bind msgm - "!сказать*" hos:say
bind msgm - "!say*" hos:say
bind pubm - "$hosp(chan) !ранд*" hos:prand
bind msgm - "!ранд*" hos:mrand
bind msgm - "!союзники*" hos:alnc
bind msgm - "!роль*" hos:wrole

#Комманды во время ночи
bind msgm - "!проверить*" hos:check
bind msgm - "!check*" hos:check
bind msgm - "!изолировать*" hos:isol
bind msgm - "!isolate*" hos:isol
bind msgm - "!соблазнить*" hos:sobl
bind msgm - "!tempt*" hos:sobl
bind msgm - "!избить*" hos:izbit
bind msgm - "!beat*" hos:izbit
bind msgm - "!заговорить*" hos:crazy
bind msgm - "!crazy*" hos:crazy
#bind msgm - "!раскаяться*" hos:rask
#bind msgm - "!repent*" hos:rask
bind msgm - "!помочь*" hos:heal
bind msgm - "!help*" hos:heal
bind msgm - "!!избить*" hos:madiz
bind msgm - "!!проверить*" hos:madiz
bind msgm - "!!защитить*" hos:madiz
bind msgm - "!!beat*" hos:madiz
bind msgm - "!!check*" hos:madiz
bind msgm - "!!protect*" hos:madiz


proc hos:phult {nick uhost handle chan text} {
	global hosp
	if {$chan!=$hosp(chan)} {return}
	if {$hosp(ishulted)==1} {return}
	if {![hos:isregister $nick]} {return}
	if {[hos:getinfo level $nick]==0} {return}
	if {![hos:isidentify $nick]} {
		putserv "PRIVMSG $nick :\002\00314Вы должны идентифицироваться. Для этого надо набрать \0037!identify\00314 мне в приват."
		return
	}
	set hosp(isgame) 0
	set hosp(isreg) 0
	set hosp(night) 0
	set hosp(ishulted) 1
	hos:killtimers
	putserv "mode $chan -m"
	foreach val $hosp(players) {
		if {[onchan $val $hosp(chan)]} {pushmode $hosp(chan) -v $val}
	}
	set hosp(players) ""
	set hosp(gplayers) ""
	putserv "PRIVMSG $chan :\002\00314Игра остановлена. Бот заморожен."
}

proc hos:mhult {nick uhost handle text} {
	global hosp
	if {$hosp(ishulted)==1} {return}
	if {![hos:isregister $nick]} {return}
	if {[hos:getinfo level $nick]==0} {return}
	if {![hos:isidentify $nick]} {
		putserv "PRIVMSG $nick :\002\00314Вы должны идентифицироваться. Для этого надо набрать \0037!identify\00314 мне в приват."
		return
	}
	set hosp(isgame) 0
	set hosp(isreg) 0
	set hosp(night) 0
	set hosp(ishulted) 1
	hos:killtimers
	putserv "mode $chan -m"
	foreach val $hosp(players) {
		if {[onchan $val $hosp(chan)]} {pushmode $hosp(chan) -v $val}
	}
	set hosp(players) ""
	set hosp(gplayers) ""
	putserv "PRIVMSG $hosp(chan) :\002\00314Игра остановлена. Бот заморожен."
}

proc hos:sfullwon {nick uhost handle chan text} {
	global hosp
	set who [lindex $text 1]
	if {$who==""} {set who $nick} elseif {$who!=""} {set who [hos:ispersn $who]}
	if {![hos:isplayed $who]} {
		putserv "PRIVMSG $chan :\002\00314Человек по имени\0033 $who\00314 пока не сыграл ни в одной игре.\003"
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
