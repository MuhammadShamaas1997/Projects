import pyautogui
import time
#'557143089312305','2504955766302620','648084152338972','5236475669763760','385981950169285',
#groups = ['3150329495208221','386244536811413','1025922941391910','736275661037966','5388120477901043','330217302625849','1423417324841311','1181189242680501','598825541960540','907671873958151','5258082730934352','726389418599823','559553482371462','1117647375628407','374465448029698','365851378780512','7753553271352439','1098941180978678','427074749425222','5906168429400437','3304887996498056','414989127216919','5388583037852269','5363362533729640','3274274849528510','2877409089228023','1238125896989007','425235332944765','5805197272921614','5311012285680062','5280387868684296','4887007494742619','3162317137364453','2019962381521892','1882910435253078','1853060381751896','1727072674292366','1458549854616033','1457446458027516','1176960403065349','1170670266838649','1156038331847002','1085061758746484','1076970926532785','1066095817333013','998380970855181','980856399261003','808961453413243','792420522134778','771939663992266','768004551237492','744386626758364','742724273742370','719019149403053','700403974569525','607039380850857','597901354870809','596685318370103','588846719303922','574213640760035','570956671133204','545476680643443','544672250728831','541377877770472','513335767244384','493130279278315','445506603594737','436364091352230','409295460943759','404938258238950','402058201869829','384799093489977','361008789469459','357084156362043','355283500025260','349306097319501','344622394452460','424526686193027','440306600849504','427022572378751','3126712694260136','735217967684538','711119343443497','396914372454823','332921655672456','1415020505589264','1205962736845256',
#groups = ['1195093357921071','1177644143060262','1139000523494433','1093187738212509','769052424510861','741623200298182','729242871628698','711678946724913','574372274086826','571277691237738','570032031399915','565888908256446','555100066167838','536694331449412','394906462605939','5932679876759960','5092684997521528','2861812103962423','717700169451763','5221384667946943','2095728940609176','1738375256498723','1609951692721571','1241203266638851','1221824158573099','1189049638535654','3275869965981451','3179612955626541','3146587558938477','2238142253011390','2181464915363906','2152074651619514','1863355047197171','1676907859326901','1488275798253417','1406938473143493','1369611963521888','1203437457120640','1201695990605986','1161567204688281','1150952682137430','3241214492827071','3181016688831247','2321722997997005','1732794103740644','1627546490979613','1577943649340923','1260171444779222','1251063372386555','1202023127296177','1143906996173687','1116388752590405','1084886985714935','431668168813371','412400847125718','1046526516266136','2160677707440851','375966981256519','592850145387787','547633283493944','707229937141026','531632118577851','528152935683470','478448130746092','430714688792321','1464701550626780','1445765735865097','621026932576141','420607123299758','340000471648533','5464851493565331','1672697209754188','1476759672761674','1448660958932724','1432809520465148','1143978192815128','1105769960020017','1032182150822148','697507008016166','532611488563862','480869130509899','439346867733792','420393839997149','397652255655797','387946976731730','361795369224864','358608886223291','306581301593301','5456928721037795','1395659034251456',
groups = ['1308645263041144','1088722858660417','571245784592782','552223223035960','548112086797409','492686105963737','446117340290169','424483169554504','403095528265441','369885518386408','368993012025836','362993542612907','351248323747349','342951531355871','317438680589178','434703801532630','708622226876540','549824480196928','4769997383105339','3318720961730754','3298263287110125','3101446040166680','2556210731181578','2238083289689190','2186586318185592','2050153015168129','1643171652733614','1406963573155755','1389503244870690','1361984807622756','1280068149188448','1239720740130636','1204228457025860','1203115127118041','1180301255843289','1174864063247449','1174309933362448','1172713166847744','1141205463402316','1090616641804223','1090111301882381','1072144780353155','1063747481247208','1030811017640262','1020729055255828','1017097002509478','1004955946839011','983270135623779','980262365998702','969611787040581','882071406083484','778182970263694','757055682393845','718726162683079','718085546084447','714764729599369','711587976809976','698698584724983','692407718490753','689955625406627','593332905411975','584600946347856','580519163490099','575737767243674','566580398379207','564256451757261','559371145569020','555461866208899','549438390160227','531455395345815','524995572743121','465645552123077','454860999784137','446515213972307','434720038522812','414805040367769','399034768837379','397714772376106','394010945860302','386599286867830','377460477702036','346033310979583','342922674665956','331520275845425','322923590046618','286061090342659','831958994448157','820778158889205','735046727545886','702922657446506','620631468928337','600467861216380','582825963412808','435699621735883','433031938368340','379889340788066','369818655242525','349471057140854','1068558087406321','1061149667831064','1057232791888318','1008653850041769','980746099212112','773461690500512','760434925128861','724682408540815','720498745953912','710223940185207','708174240438742','708049977147008','706191457333852','699702384472128','684351339530663','592780805494567','582840836545274','581082873672085','580387260113302','571567334334137','570994468026008','557739942683194','553764419562245','551878933142584','537103944734830','532615601942194','531945758619621','508893437587654','497212808846139','440495540853427','439731307621453','437906238118353','429660398804029','423154379699678','418798343648446','417875576896237','380003197559982','352932523653447','335502091924981','993967851245198','729321248267015','707712130509751','585628606307174','580883593407920','577481927178401','560601512345064','549454906817836','544117234053211','447101063415430','447053500089979','442632707262392','439550654679523','436401477992106','425028209256359','422420902900572','417442003595274','386901186792128','362552212633914','355755753330943','322370953414999','1056286724990729','739895663818256','698851811408555','341163357996099','5531848440168866','5525624224135855','5226343787441219','1416571895491609','1374090703096167','1201007553992321','1128156307730499','1105277400070248','1080094052945512','784245942947275','777927636552049','775097610570243','770680100781029','752110762480927','747157976433406','746500190108014','601853441197770','563854978454087','563172791964248','560399558891538','557529379157718','557247646047962','554879076096717','545438847060106','534762131767217','392170406310736','361163552817595','352776203672269']
print(len(groups))
time.sleep(10)

pyautogui.keyDown('ctrl')
pyautogui.keyDown('t')
pyautogui.keyUp('t')
pyautogui.keyUp('ctrl')

for i in range(len(groups)):
    link = 'https://facebook.com/groups/'+groups[i]
    pyautogui.typewrite(link)
    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')

    print("Waiting for 45 seconds\n")
    time.sleep(10)

    pyautogui.moveTo(531, 405)
    pyautogui.click()

    time.sleep(5)
    print("Writing post\n")
    pyautogui.typewrite('Welcome to the group')
    time.sleep(5)    
    
    #for n in range(45):
    #    print(pyautogui.position())
    
    for n in range(9):
        pyautogui.keyDown('tab')
        pyautogui.keyUp('tab')

    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')

    time.sleep(10)

    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('w')
    pyautogui.keyUp('ctrl')
    pyautogui.keyUp('w')
    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('t')
    pyautogui.keyUp('t')
    pyautogui.keyUp('ctrl')

    time.sleep(5)


