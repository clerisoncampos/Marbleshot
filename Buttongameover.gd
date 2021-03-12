extends Button

func _ready():
	pass 

func pressed():
    get_tree().change_scene("res://cenas/MenuInicial.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
