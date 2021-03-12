extends Node2D
onready var desafio1 = preload("res://cenas/desafio1.tscn").instance()
onready var lionface = preload("res://cenas/lionface.tscn").instance()
onready var explo = preload("res://cenas/explosion.tscn").instance()
onready var bola = preload("res://cenas/bola.tscn")
onready var cometa = preload("res://cenas/comet.tscn")
onready var medusa = preload("res://cenas/medusa.tscn")
onready var player = get_node("player")
onready var bullet = get_node("bullet")
onready var tlife = get_node("life")
onready var tscore = get_node("score")
var velplayer = 4
var numblocos = 10
var podeatirar=true
var veltiro = 10
var lionmov = 0
var vel_lion = 2
var t_positions = [[-150,-52],[-50,-52],[50,-52],[150,-52],[250,-52],[-200,52],[-100,52],[0,52],[100,52],[200,52]]
var new_positions = []
var tempoblocoativo=2
var sobedupla05 = 0
var sobedupla16 = 0
var sobedupla27 = 0
var sobedupla38 = 0
var sobedupla49 = 0
var velbloco = 3
var score = 0
var life = 30
var lifelion = 40
var chuvacometa = 0 #0 nulo/ 1 instancia/ 3 processa score
var fasecometa = 11 #quando o lifelion atinge 6 começam os cometas
var fasemedusa = 14 # quando o lifelion atinge 14 começam as medusas
var instanciamedusa = 0

func _ready():
    self.add_child(desafio1)
    self.add_child(lionface)
    self.add_child(explo)
    player.connect("body_entered",self,"collide_player") 
    for i in range(numblocos): 
         desafio1.get_node("bl"+str(i)).connect("area_entered",self,"collide_bloco",[i]) 
         desafio1.get_node("bl"+str(i)+"/Timer").wait_time=tempoblocoativo
         desafio1.get_node("bl"+str(i)+"/Timer").connect("timeout",self,"tempo_bloco_fim",[i]) 
    lionface.get_node("lion").connect("area_entered",self,"collide_lion")
    move_child(desafio1, 1)
    move_child(lionface, 2)
    move_child(explo, 4)
    desafio1.position.x = 370
    desafio1.position.y = 230
    #---mistura posições e aplica aos blocos
    new_positions = mistura(t_positions)
    #for i in range(new_positions.size()): print(new_positions[i])
    posiciona_blocos()
    #lionface.get_node("animlion").play("redlion")




func _process(delta):
    movimenta_nave()
    processatiro()
    verifica_dupla()
    tlife.text=str(life)
    tscore.text=str(score)
    get_node("/root/global").scoregeral = score
    if (life<=0):  get_tree().change_scene("res://cenas/gameover.tscn")
    chovecometa()
    medusa()
    lionface.get_node("lion/life").text = str(lifelion)
    if (lifelion<=0):
        lifelion=0
        lionface.position.y-=1
        #lionface.rotation-=0.1
        lionface.modulate.a-=0.02
        #lionface.scale.x+=2
        #lionface.scale.y+=2
        if lionface.position.y<-100: get_tree().change_scene("res://cenas/congratulation.tscn")
    else: 
        movimenta_lion()   
	
    
   

#-------------------------funçoes----------------------------
func movimenta_nave():
   if Input.is_key_pressed(KEY_LEFT) and player.position.x>150: player.position.x=player.position.x-velplayer
   if Input.is_key_pressed(KEY_RIGHT) and player.position.x<615: player.position.x=player.position.x+velplayer
  
func collide_bloco (area,i):
	 var this = desafio1.get_node("bl"+str(i))
	 #print(area.get_name())
	 if area.get_name()=="bullet":
	   this.get_node("Sprite2").visible=true
	   this.get_node("Timer").start()
	   bullet.position.x=-100
	
func collide_lion(area):
	if area.get_name()=="bullet":
	   #print(area.get_name())
	   lionface.get_node("animlion").play("redlion")
	   bullet.position.x=-100
	   lifelion-=1
	   score+=10
	
func processatiro():
	if Input.is_key_pressed(KEY_UP) and podeatirar==true: 
        bullet.position.x = player.position.x
        bullet.position.y = player.position.y-20
        podeatirar = false
	if (bullet.position.y<-10): podeatirar=true
	else: bullet.position.y-=veltiro
	
func movimenta_lion():
	var limitedir=250
	var limiteesq=-180
	if lionmov==0:
		lionface.position.x+=vel_lion;
		if lionface.position.x>limitedir: lionmov = 1
	if lionmov==1:
		lionface.position.x-=vel_lion
		if lionface.position.x<limiteesq: lionmov = 0	
	
func tempo_bloco_fim (i):
    desafio1.get_node("bl"+str(i)+"/Sprite2").visible=false


func mistura(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        randomize()
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList
	
func posiciona_blocos():
	for i in range(numblocos): 
         desafio1.get_node("bl"+str(i)).position.x = new_positions[i][0]
         desafio1.get_node("bl"+str(i)).position.y = new_positions[i][1]

func verifica_dupla():
#se os dois da dupla for visivel----------------------------
    for i in range(numblocos/2):
        if desafio1.get_node("bl"+str(i)+"/Sprite2").visible==true and desafio1.get_node("bl"+str(i+5)+"/Sprite2").visible==true and get("sobedupla"+str(i)+str(i+5))==0: set("sobedupla"+str(i)+str(i+5),1)
    for i in range(numblocos/2):
        if get("sobedupla"+str(i)+str(i+5))>0:
               desafio1.get_node("bl"+str(i)).position.y-=velbloco
               desafio1.get_node("bl"+str(i)).rotation+=0.1
               desafio1.get_node("bl"+str(i)).modulate.a-=0.05
               desafio1.get_node("bl"+str(i+5)).position.y-=velbloco
               desafio1.get_node("bl"+str(i+5)).rotation+=0.1
               desafio1.get_node("bl"+str(i+5)).modulate.a-=0.05
        if get("sobedupla"+str(i)+str(i+5))==1:
                      var ballx = bola.instance()
                      self.add_child(ballx)
                      move_child(ballx, 3)
                      score+=10
                      set("sobedupla"+str(i)+str(i+5),2)

func collide_player(area):
	#print(area.get_name())
	explo.position.x=player.position.x-20
	explo.position.y=player.position.y-20
	explo.get_node("AnimationPlayer").play("animexplosion")
	life-=1
	
func chovecometa():
     if lifelion<fasecometa and chuvacometa==0: 
        for i in range (3): 
             var cmt = cometa.instance()
             self.add_child(cmt)
             cmt.get_node("comet").connect("area_entered",self,"collide_cometa") 
             cmt.position.x=i*120
             cmt.position.y=-1*100*i
        chuvacometa=1
		
func medusa():
     if lifelion<fasemedusa and instanciamedusa==0: 
        for i in range (2): 
             var me = medusa.instance()
             self.add_child(me)
             me.get_node("medusahead").connect("area_entered",self,"collide_medusa") 
             me.position.x=-180
        instanciamedusa=1

func collide_cometa(area):
  #print(area.get_name())
  if area.get_name()=="player":
     explo.position.x=player.position.x-20
     explo.position.y=player.position.y-20
     explo.get_node("AnimationPlayer").play("animexplosion")
     life-=2

func collide_medusa(area):
  #print(area.get_name())
  if area.get_name()=="player":
     explo.position.x=player.position.x-20
     explo.position.y=player.position.y-20
     explo.get_node("AnimationPlayer").play("animexplosion")
     life-=2
