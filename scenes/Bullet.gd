extends Area2D

var velocity  = Vector2()
export var SPEED = 2000
var kill_mob = false

func _ready():
	set_physics_process(true)
	
func start_at(diretion, pos):
	rotation = diretion.angle() + PI/2
	position = pos
	velocity = diretion * SPEED

func _physics_process(delta):
	set_position(position + velocity * delta)


func _on_Bullet_body_entered(body):
	if body.name.find("BigMob") >= 0 and not kill_mob:
		kill_mob = true
		body.kill(position)
	elif body.name.find("Mob") >= 0 and not kill_mob:
		kill_mob = true
		body.kill()
	queue_free()
