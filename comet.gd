extends Area2D
var vel=5

func _ready():
	pass 

func _process(delta):
	position.y=position.y+vel
	if (position.y>800): 
        position.y=-50
        position.x=randi()%400+10

