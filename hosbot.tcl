if {![array exist hosp]} { 
  set hosp(chan) "#maf"
  set hosp(isgame) 0
  set hosp(night) 0
  set hosp(morn) 0
  set hosp(isreg) 0
  set hosp(ishulted) 0
  set hosp(isgolo1) 0
  set hosp(isgolo2) 0
  set hosp(tmpfile) "scripts/hospital/tempfile.txt"
  set hosp(plfile) "scripts/hospital/plfile.txt"
  set hosp(regus) "scripts/hospital/regus.txt"
  set hosp(regnicks) ""
  set hosp(players) ""
  set hosp(gplayers) ""
  set hosp(splayers) ""
  set hosp(unr) ""
  #Роли
  set hosp(psy) ""
  set hosp(main) "" 
  set hosp(sis) ""
  set hosp(nev) ""
  set hosp(san) ""
  set hosp(sym) ""
  set hosp(shiz) ""
  set hosp(nim) ""
  set hosp(mad) ""
  #Фразы для ролей
  set hosp(fmain) ""
  set hosp(fsis) ""
  set hosp(fnev) ""
  set hosp(fsan) ""
  set hosp(fnim) ""
  set hosp(fmad) ""
  set hosp(fshiz) ""
  set hosp(fsym) ""
  #Количество ролей
  set hosp(numpsy) 0
  set hosp(nummain) 0 
  set hosp(numsis) 0
  set hosp(numnev) 0
  set hosp(numsan) 0
  set hosp(numsym) 0
  set hosp(numshiz) 0
  set hosp(numnim) 0
  set hosp(nummad) 0
  set hosp(numzag) 0
  #На кого походил такой-то
  set hosp(wnim) ""
  set hosp(wmain) ""
  set hosp(wsis) ""
  set hosp(wsan) ""
  set hosp(wsym) ""
  set hosp(wmad) ""
  set hosp(wnev) ""
  set hosp(wshiz) ""
  set hosp(maind) 0 
  set hosp(sisd) 0
  set hosp(nevd) 0
  set hosp(sand) 0
  set hosp(symd) 0
  set hosp(shizd) 0
  set hosp(nimd) 0
  set hosp(madd) 0
  set hosp(madi) 0
  #Показатели на ходы ролей
  set hosp(nm) 1
  set hosp(wmaini) 0
  set hosp(wnevi) 0
  set hosp(qsan) 0
  set hosp(nimpriv) ""
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
  #Для голосования
  set hosp(glplayers) ""
  set hosp(glwhom) ""
  set hosp(conf) ""
  set hosp(gmax) 0
  set hosp(qgmax) 0
  set hosp(dobl) 0
}

source "scripts/hospital/binds.tcl"
source "scripts/hospital/night.tcl"
source "scripts/hospital/nicks.tcl"
source "scripts/hospital/roles.tcl"
source "scripts/hospital/oper.tcl"
source "scripts/hospital/morn.tcl"
source "scripts/hospital/golo.tcl"
source "scripts/hospital/reg.tcl"
source "scripts/hospital/file.tcl"
source "scripts/hospital/mesg.tcl"
source "scripts/hospital/help.tcl"

proc hos:killtimers {} {
  foreach e [utimers] {if {[string first "hos:" $e]!=-1} {killutimer [lindex $e 2]}}
}
