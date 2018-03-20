extends RigidBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
var mob_types = ["walk", "swim", "fly"]

signal boom


func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
#func _process(delta):
#	print($Visibility.is_on_screen())


func kill():
	emit_signal("boom", position)
	queue_free()

func _on_Visibility_screen_exited():
	print("sai da tela")
	queue_free()
