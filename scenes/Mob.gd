extends RigidBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
var mob_types = ["walk", "swim", "fly"]

signal boom


func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
#func _physics_process(delta):
#	move_and_collide(Vector2(0, rand_range(MIN_SPEED, MAX_SPEED)*delta)) # Move down 1 pixel per physics frame


func kill():
	emit_signal("boom", position)
	queue_free()

func _on_Visibility_screen_exited():
	queue_free()
