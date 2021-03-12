extends Area2D
var vel=3
var n = 0
var altura = 60
var posy = 400
var d = 1

func _ready():
	d=(randi()%2+1)/10
	pass 

func _process(delta):
	position.x=position.x-vel
	n=n+0.05
	position.y=sin(n)*altura+posy
	if (position.x<-200): 
        posy=randi()%400+350
        position.x=randi()%1500+900

