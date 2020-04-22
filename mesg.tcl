proc hos:mes {mes} {
	regsub -all -- {\\\\} $mes !1 mes
	regsub -all -- {\\\[} $mes !2 mes
	regsub -all -- {\\\]} $mes !3 mes
	regsub -all -- {\\\{} $mes !5 mes
	regsub -all -- {\\\}} $mes !4 mes
	regsub -all -- {\\\^} $mes !6 mes
	regsub -all -- {\\\"} $mes !7 mes
	regsub -all -- {\{} $mes {} mes
	regsub -all -- {\}} $mes {} mes
	regsub -all -- {\\} $mes {} mes
	regsub -all -- !1 $mes \\ mes
	regsub -all -- !2 $mes \[ mes
	regsub -all -- !3 $mes \] mes
	regsub -all -- !4 $mes \} mes
	regsub -all -- !5 $mes \{ mes
	regsub -all -- !6 $mes \^ mes
	regsub -all -- !7 $mes \" mes
	return $mes
}

proc hos:prand {nick uhost handle chan text} {
	global hosp
	if {$hosp(isgolo1)} {
		set res [lindex $hosp(gplayers) [expr [rand [llength $hosp(gplayers)]]]]
		putserv "PRIVMSG $hosp(chan) :\00314Тебе\0033 $nick\00314 выпало вешать\0034 $res\00314."
		return
	} elseif {$hosp(isgolo2)} {
		set t [rand 2]
		if {$t} {putserv "PRIVMSG $hosp(chan) :\00314Тебе\0033 $nick\00314 выпало\0035 да\00314."} else {putserv "PRIVMSG $hosp(chan) :\00314Тебе\0033 $nick\00314 выпало\0035 нет\00314."}
		return
	} else {
		set t [lindex $text 1]
		if {$t==""} {set t [rand 9]} else {set t [rand $t]}
		incr t
		set res $t

	}
	putserv "PRIVMSG $hosp(chan) :Результат - $res"
}

proc hos:mrand {nick uhost handle chan text} {
	global hosp
	if {!$hosp(isgame) || $hosp(isreg)} {
		set res [expr [rand [llength $hosp(gplayers)]]]
		putserv "PRIVMSG $hosp(chan) :Результат - $res"
	}
}

proc hos:mainch {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Просмотрев несколько личных дел больных, \0032главврач\00314 узнал, кто такой\0033 $hosp(wmain)\00314."]}
		1 {set mes [lappend mes "\00314Сегодня\0032 Главврач\00314 откопал в недрах своего шкафа историю болезни\0033 $hosp(wmain)\00314."]}
	}
	set mes [lappend mes "\0037 Таблеток: +10"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizmain {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Главврач\0033 $hosp(main)\00314 перенапрягся на работе и заперся изнутри в карантинном боксе, съев ключи!"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizsis {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Упившись вусмерть палёным коньяком\0032 Главврач\00314 обматерил\0032 Медсестру\0033 $hosp(sis)\00314, у которой в результате случился нервный срыв. Пришлось её запереть на карантин."]
	set mes [lappend mes "\0037 Таблеток: -150"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizpsy {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня\0032 Главврач\00314 хватил лишку и пинками загнал в карантинный бокс совершенно безобидного\0032 Психа\0033 $hosp(wmain)\00314."]
	set mes [lappend mes "\0037 Таблеток: -50"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainiznev {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Сегодня ночью\0032 Главврач\00314 за что-то крепко обиделся на\0032 Невропатолога\0033 $hosp(nev)\00314. Придётся ему теперь искать другую работу."]}
		1 {set mes [lappend mes "\0032Невропатолог\0033 $hosp(wmain)\00314 спросонья надел одежду какого-то пациента за что был пойман и заперт\0032 Главврачом."]}
	}
	set mes [lappend mes "\0037 Таблеток: -100"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizsan {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Во время ночного обхода\0032 Главврач\00314 поймал\0032 Санитара\0033 $hosp(wmain)\00314 за принятием отобранных у пациентов таблеток и, набив морду, уволил без выходного пособия!"]}
		1 {set mes [lappend mes "\0032Главврач\00314 ночью застукал\0032 санитара\0033 $hosp(wmain)\00314 за неугодным делом, за что и изолировал от откружающих."]}
	}
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizsym {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Возвращаясь с ночного обхода, \0032Главврач\00314 застал в своём кабинете\0032 Симулянта\0033 $hosp(wmain)\00314, роющегося в документах и пинками гнал его от больницы до военкомата."]}
		1 {set mes [lappend mes "\0032Главврач прочитал дело\0032 Симулянта\0033 $hosp(wmain)\00314 и нашел, что тот нуждается в изоляторе."]}
	}
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainizmad {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Главврач\00314 ночью выследил\0032 Буйного\0033 $hosp(wmain)\00314 и, вкатив ему лошадиную дозу успокоительного, запер в карантинном боксе."]}
		1 {set mes [lappend mes "\0032Буйный\0033 $hosp(wmain)\00314 ночью повздорил с\0032 Главврачом\00314 и был заперт в изоляторе."]}
	}
	set mes [lappend mes "\0037 Таблеток: +75"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:mainiznim {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Нимфоманке\0033 $hosp(wmain)\00314 не удалось соблазнить \0032Главврача\00314. В результате тот запер её в карантинном боксе, чтоб не отвлекала от работы."]}
		1 {set mes [lappend mes "\0032Нимфоманка\0033 $hosp(wmain)\00314 зря скрывалась от\0032 Главврача\00314: он ее все равно нашел и запер."]}
	}
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagmain {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Ночью \0032Шизофреник\00314 явился в кабинет \0032Главврача\0033 $hosp(wshiz)\00314 и долго с ним о чём-то беседовал. Наутро тот сам заперся в изоляторе."]}
		1 {set mes [lappend mes "\0032Главврача\0033 $hosp(wshiz)\00313 этой ночью подстерег болтливый\0032 Шизофреник\00314 и заговорил его так, что тот сбежал из больницы."]}
	}
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagsis {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня \0032Шизик\00314 подкараулил\0032 Медсестру\0033 $hosp(wshiz)\00314 и наговорил ей много страшных вещей. Бедная девушка не выдержала морального давления и уволилась."]
	set mes [lappend mes "\0037 Таблеток: +100"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}
proc hos:shizzagnev {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Невропатолог\0033 $hosp(wshiz)\00314 на свою голову встретил сегодня\0032 Шизика\00314 и тот мягко и нанавязчиво убедил его зкрыться в изоляторе, схесть ключ и никому не мешать."]
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}


proc hos:mainizshiz {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Главврач\00314 сегодня наконец-то выследил\0032 Шизофреника\0033 $hosp(wmain)\00314, сбивавшего прочих пациентов с пути истинного, и прописал ему курс интенсивной терапии."]}
		1 {set mes [lappend mes "\0032Шизофреник\0033 $hosp(wmain)\00314 днем вел себя плохо, за что был заперт в изоляторе\0032 Главврачом\00314."]}
	}
	set mes [lappend mes "\0037 Таблеток: +70"]
	if {$hosp(fmain)!=""} {set mes [lappend mes "\00314Главврач объявляет:\0036 $hosp(fmain)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagsan {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Встретив в коридоре\0032 Санитара\0033 $hosp(wshiz)\00314, \0032Шизик\00314 рассказал ему много интересного. Санитар с горя напился и уволился по собственному желанию."]
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagpsy {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Прокравшись ночью в чужую палату, \0032Шизофреник\00314 что-то долго втолковывал \0032Мирному Психу\0033 $hosp(wshiz)\00314, после чего тот до утра бился головой об стенку. Утром пришлось везти вреанимацию."]
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagsym {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Симулянт\0033 $hosp(wshiz)\00314 после долгой беседы с\0032 Шизофреником\00314 сбежал из больницы и пришёл в военкомат прямо посреди ночи."]
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagmad {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня\0032 Шизик\00314 убедил\0032 Буйного\0033 $hosp(wshiz)\00314 больше не буянить."]
	set mes [lappend mes "\0037 Таблеток: +40"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagnim {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Нимфоманка\0033 $hosp(wshiz)\00314 встречалась с\0032 Шизиком\00314 вовсе не для содержательной беседы, но он оказался импотентом и разбил девушке сердце самым жестоким образом. С горя она заперлась в изоляторе."]}
		1 {set mes [lappend mes "\0032Шизофреник сегодня всю ночь проболтал с\0032 Нимфоманкой\0032 $hosp(wshiz)\00314. Бедняжку пришлось запереть в изоляторе."]}
	}
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizzagshiz {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Не найдя подходящего собеседника, \0032Шизик\0033 $hosp(shiz) \00314 решил поговорить сам с собой и свихнулся окончательно - сам надел смирительную рубашку и заперся в карантинном боксе."]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:medshiz {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314После беседы с\0032 Шизофреником\0033 $hosp(wsis) непременно угодил бы в отделение для особо буйных, если бы Медсестра вовремя не напоила бы его успокоительным."]}
		1 {set mes [lappend mes "\0032Шизофреник попытался изолировать\0033 $hosp(wshiz)\00314, но вовремя подоспевшая\0032 медсестра\00314 успокоила больного."]}
	}
	if {$hosp(fsis)!=""} {set mes [lappend mes "\00314Медсестра шепчет:\0036 $hosp(fsis)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}


proc hos:mednev {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Невропатолог\00314 хотел было упаковать в смирительную рубашку\0033 $hosp(wnev)\00314, но\0032 Медсестра\00314 убедила его отказаться от задуманного."]}
		1 {set mes [lappend mes "\0032Невропатолог запер в изоляторе \0033$hosp(wnev)\00314, но \0032медсестра\00314 выпустила потерпевшего."]}
	}
	if {$hosp(fsis)!=""} {set mes [lappend mes "\00314Медсестра шепчет:\0036 $hosp(fsis)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:medsan {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Санитары\00314 избили до полусмерти \0033$hosp(wsan)\00314, но стараниями\0032 медсестры\00314 несчастный был спасен."]}
		1 {set mes [lappend mes "\0032Санитары\00314 сегодня подкарауливали в коридоре\0033 $hosp(wsan)\00314, но громкий визг\0032 Медстестры\00314 заставил их отказаться от задуманного."]}
	}
	if {$hosp(fsis)!=""} {set mes [lappend mes "\00314Медсестра шепчет:\0036 $hosp(fsis)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:medmad {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Буйный\00314 чуть не размазал\0033 $hosp(wmad)\00314 по стенке, но\0032 медсестра\00314 заранее накормила первого снотворным."]}
		1 {set mes [lappend mes "\0032Буйный\00314 всю ночь выслеживал\0033 $hosp(wmad)\00314, но в последний момент был отвлечён\0032 Медсестрой\00314."]}
	}
	if {$hosp(fsis)!=""} {set mes [lappend mes "\00314Медсестра шепчет:\0036 $hosp(fsis)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:medmain {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Пьяный\0032 Главврач\00314, угрожая скальпелем, зачем-то пристал ночью к\0033 $hosp(wmain)\00314, но храбрая\0032 Медсестра\00314 сделал ему укол успокоительного и увела в кабинет."]
	if {$hosp(fsis)!=""} {set mes [lappend mes "\00314Медсестра шепчет:\0036 $hosp(fsis)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:neviznev {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Невропатолог\0033 $hosp(nev)\00314 сегодня напился вусмерть и с горя уволился."]}
		1 {set mes [lappend mes "\0032Невропатолог\0033 $hosp(wnev)\00314 зачем-то зашел в изолятор и заперев дверь, вспомнил, что забыл ключ снаружи."]}
	}
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizsis {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня\0032 Невропатолог\00314, видимо, совсем взбесился и запер в подсобке \0032Медсестру\0033 $hosp(wnev)\00314, выкинув ключ в окно!"]
	set mes [lappend mes "\0037 Таблеток: -150"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizpsy {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Невропатолог\00314 ночью, ни фига не разглядев, запихал обычного\0032 Психа\0033 $hosp(wnev)\00314 в смирительную рубашку и запер в карантинном боксе!"]
	set mes [lappend mes "\0037 Таблеток: -50"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizsan {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Невропатолог\00314 подкаруил в тёмном коридоре\0032 Санитара\0033 $hosp(wnev)\00314 и, накачав транквилизаторами, упаковал в карантинный бокс!"]
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizsym {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня\0032 Невропатолог\00314 выявил косившего от армии\0032 Симулянта\0033 $hosp(wnev)\00314 и назначил ему такой курс лечения, что тот добровольно пришёл в военкомат."]
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizshiz {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Отловив в тёмном коридоре\0032 Шизика\0033 $hosp(wnev)\00314,\0032 Невропатолог\00314 вкатил ему такую дозу успокоительного, что лежит он теперь в токсикологии."]
	set mes [lappend mes "\0037 Таблеток: +70"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nevizmad {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Невропатолог\00314 оглоушил шедшего по своим делам и подозрительно тихого\0032 Буйного\0033 $hosp(wnev)\00314 резиновым молотком по затылку и привязал к кровати в карантинном боксе."]
	set mes [lappend mes "\0037 Таблеток: +75"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:neviznim {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Нимфоманка\0033 $hosp(wnev)\00314 чем-то не понравилась\0032 Невропатологу\00314, за что и была заперта в карантинном боксе."]
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fnev)!=""} {set mes [lappend mes "\00314Невропалог бубнит:\0036 $hosp(fnev)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizmain {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня в больнице траур.\0032 Санитары\00314 устроили тёмную\0032 Главврачу\0033 $hosp(wsan)\00314, так что он теперь сам лечится в реанимации."]
	set mes [lappend mes "\0037 Таблеток: +45"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\0036Санитар кричит: $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizsis {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Санитары\00314 этой ночью так напугали\0032 Медсестру\0033 $hosp(wsan)\00314, что она этим же утром уволилась, поклявшись никогда больше не появляться в этой больнице."]
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:saniznev {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Подкараулив во время ночного обхода\0032 Невропатолога\0033 $hosp(wsan)\00314, злые\0032 Санитары\00314 переломали ему все конечности. Теперь он отдыхает в реанимации."]
	set mes [lappend mes "\0037 Таблеток: +40"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizsan {san} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Санитары\00314 что-то не поделили между собой, в результате чего один из них -\0033 $hosp(wsan)\00314 ещё долго будет лежать в травматологии."]}
		1 {set mes [lappend mes "\0032Санитары\00314 ночью нашли 99%ный спирт, выпили и решили, что такой санитар, как\0033 $hosp(wsan)\00314 не должен работать в больнице."]}
	}
	if {$san != $hosp(wsan)} {set mes [lappend mes "\0037 Таблеток: +40"]}
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizpsy {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Санитары\00314 поймали этой ночью спешившего по своим делам мирного\0032 Психа\0033 $hosp(wsan)\00314 и долго пинали ногами. Теперь он лежит в травматологии."]}
		1 {set mes [lappend mes "\0032Санитары\00314 ночью залезли в палату к\0032 мирным психам\00314 и забили\0033 $hosp(wsan)\00314."]}
	}
	set mes [lappend mes "\0037 Таблеток: +25"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:saniznim {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Встретив\0032 Нимфоманку\00314,\0032 Санитары\00314 основательно подпортили ей внешность и заперли в подвале."]}
		1 {set mes [lappend mes "\00314Прогуливаясь по коридорам\0032 санитары\00314 встретили\0032 нимфоманку\0033 $hosp(wsan)\00314 и жестоко над ней надругались."]}
	}
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizshiz {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Выловив ночью в коридоре\0032 Шизика\0033 $hosp(wsan)\00314,\0032 Санитары\00314 долго пинали его ногами. Он теперь больше не буянит и вообще лежит в травматологии."]
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizsym {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Санитары\00314 долго искали козла отпущения и нашли\0032 симулянта\0033 $hosp(wsan)\00314."]}
		1 {set mes [lappend mes "\0032Симулянт\00314 плохо помогал\0032 Санитарам\00314, за что и был ими сдан в военкомат."]}
	}
	set mes [lappend mes "\0037 Таблеток: -75"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:sanizmad {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\00314Сегодня\0032 Санитары\00314 поймали не в меру шустрого\0032 Буйного\0033 $hosp(wsan)\00314 и пересчитали ему все рёбра. В травматологии не особо побуянишь."]}
		1 {set mes [lappend mes "\0032Санитары\00314 шарили по палатам и наткнулись на\0032 буйного\0033 $hosp(wsan)\00314."]}
	}
	set mes [lappend mes "\0037 Таблеток: +55"]
	if {$hosp(fsan)!=""} {set mes [lappend mes "\00314Санитар кричит:\0036 $hosp(fsan)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizmain {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Шизик\00314 подкараулил\0032 Главврача\0033 $hosp(wshiz)\00314, делавшего ночной обход и дождавшись, когда тот заглянул зачем-то в пустой карантинный бокс, запер его там."]
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizsis {} {
	set mes ""
	global hosp
	set mes [lappend mes "\00314Прикинувшись пострадавшим от произвола злых Санитаров,\0032 Шизик\00314 заманил\0032 Медсестру\0033 $hosp(wshiz)\00314 в карантинный бокс, да и запер там."]
	set mes [lappend mes "\0037 Таблеток: +100"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizpsy {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Встретив ночью в коридоре безобидного\0032 Психа\0033 $hosp(wshiz)\00314,\0032 Шизик\00314 с идиотским смехом втолкнул его в пустую палату и запер на ключ!"]
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shiziznev {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Шизик\00314 сегодня ночью добрался до телефона и голосом\0032 Невропатолога\0033 $hosp(wshiz)\00314 обматерил министра здравоохраниения. Бедного доктора тотчас уволили."]
	set mes [lappend mes "\0037 Таблеток: +60"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizsan {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Санитар\0033 $hosp(wshiz)\00314 зачем-то погнался за\0032 Шизиком\00314 по незнакомому коридору, споткнулся и расшиб себе лоб. Теперь он отдыхает в травме."]
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizsym {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Сегодня ночью\0032 Шизик\00314 добрался до телефона и настучал в военкомат на\0032 Симулянта\0033 $hosp(wshiz)\00314. Утром оттуда прислали комиссию."]
	set mes [lappend mes "\0037 Таблеток: +35"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shiziznim {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Нимфоманка\0033 $hosp(wshiz)\00314 чего-то хотела от\0032 Шизика\00314, но тот оказался не в форме и, заманив её в карантинный бокс, запер там."]
	set mes [lappend mes "\0037 Таблеток: +15"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizmad {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Шизик\00314 всю ночь доставал\0032 Буйного\0033 $hosp(wshiz)\00314, под конец заманив его его в изолятор и заперев там."]
	set mes [lappend mes "\0037 Таблеток: +40"]
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:shizizshiz {} {
	global hosp
	set mes ""
	set t [rand 2]
	switch -exact -- $t {
		0 {set mes [lappend mes "\0032Шизофреник\0033 $hosp(shiz)\00314 всю ночь смотрел в окно, а под утро сбежал."]}
		1 {set mes [lappend mes "\00314Свихнувшись окончательно,\0032 Шизофреник\0033 $hosp(wshiz)\00314 заперся в первом попавшемся карантинном боксе."]}
	}
	if {$hosp(fshiz)!=""} {set mes [lappend mes "\00314Шизофреник шипит:\0036 $hosp(fshiz)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizmain {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Буйный\00314 поймал\0032 главврача\0033 $vic\00314 и вышвырнул его в окно."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizsis {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Медсестру\0033 $vic\00314 ночью приласкал\0032 буйный\00314."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizpsy {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Буйный\00314 ночью ворвался в палату к\0032 мирному психу\0033 $vic\00314 и изуродовал беднягу."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madiznev {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Невропатолог\0033 $vic\00314 засиделся до позна в своем кабинете, за что был избит\0032 буйным\00314."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizsan {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Во время очередной вылазки\0032 буйный\00314 поймал\0032 санитара\0033 $vic\00314."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizsym {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Наблюдая за окружающими\0032 буйный\00314 разглядел в\0033 $vic\0032 симулянта\00314 и решил, что ему не место в больнице."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madiznim {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Буйному\00314 ночью понравилась\0032 нимфоманка\0033 $vic\00314, и он замучил бедняжку своим садизмом."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizmad {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Буйный\0032 $vic\00314 долго гулял по больнице и, не найдя никого, под утро с разбегу стукнулся об стену. Теперь лежит в травматологии."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:madizshiz {vic sum} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Буйный\00314 повстречал\0032 шизофреника\0033 $vic\00314 и отпинал, чтобы не смущал других."]
	set mes [lappend mes "\0037 Таблеток: +$sum"]
	if {$hosp(fmad)!=""} {set mes [lappend mes "\00314Буйный бормочет:\0036 $hosp(fmad)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimmain {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Ночью\0032 Нимфоманка\00314 обнаружила, что дверь в кабинет\0032 Главврача\00314незаперта и устроила ему незабываемую ночь."]
	set mes [lappend mes "\0037 Таблеток: +55"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimnev {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Прогуливаясь по палатам,\0032 Невропатолог\00314 встретил\0032 Нимфоманку\00314 и решил никуда больше не идти."]
	set mes [lappend mes "\0037 Таблеток: +50"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimsis {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Нимфоманка\00314 ночью заглянула в сестринскую и нашла там отдыхающую\0032 Медсестру\00314."]
	set mes [lappend mes "\0037 Таблеток: +35"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimpsy {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Нимфоманка\00314 решила далеко не ходить, а заглянуть в палату своего соседа -\0032Мирного психа\00314."]
	set mes [lappend mes "\0037 Таблеток: +25"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimsan {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314 Днем\0032Нимфоманке\00314 понравился один\0032 Санитар\00314, поэтому она решила попробовать его ночью."]
	set mes [lappend mes "\0037 Таблеток: +45"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimsym {} {
	global hosp
	set mes ""
	set mes [lappend mes "\0032Нимфоманке\00314 надоели больные, и она решила поискать что-нить по-экзотичнее. В итоге нашла\0032 Симулянта\00314."]
	set mes [lappend mes "\0037 Таблеток: +40"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimshiz {} {
	global hosp
	set mes ""
	set mes [lappend mes "Днем \0032Нимфоманку\00314 очень впечатлила речь\0032 Шизофреника\00314, поэтому ночью она не задумываясь бросилась к нему."]
	set mes [lappend mes "\0037 Таблеток: +35"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimmad {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Больная\0032 Нимфоманка\00314 оказалась еще и мазохисткой, поэтому провела ночь с\0032 Буйным\00314."]
	set mes [lappend mes "\0037 Таблеток: +30"]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}

proc hos:nimnim {} {
	global hosp
	set mes ""
	set mes [lappend mes "\00314Ночью\0032 Нимфоманке\00314 не удалось погулять, так как ее дверь была заперта снаружи. Что она делала наидене с самой собой, остается только догадываться."]
	if {$hosp(fnim)!=""} {set mes [lappend mes "\00314Нимфоманка воркует:\0036 $hosp(fnim)"]}
	set mes [hos:mes $mes]
	putserv "PRIVMSG $hosp(chan) :$mes"
}
