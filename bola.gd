extends KinematicBody2D
var movement = Vector2(-3,1)
var velbola = 50

func _ready():
	pass 

func _process(delta):
     var collision = self.move_and_collide(movement*velbola * delta)
     if collision:
          movement = movement.bounce(collision.normal)
          
