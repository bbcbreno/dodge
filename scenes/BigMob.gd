extends RigidBody2D

var live = 4

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
#func _process(delta):
#
#	pass
	
func kill(touch_position):
	live -= 1
	if live == 0:
		emit_signal("boom", position)
		queue_free()
	apply_impulse(touch_position, (position - touch_position)/8 + Vector2(0, -100))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Area2D_body_entered(body):
	print (body.name)
	if body.name.find("Mob") >= 0 and body.name.find("BigMob") < 0:
		print("morra!")
		#body.queue_free()
		body.kill()
