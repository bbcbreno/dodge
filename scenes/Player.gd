extends Area2D

signal hit

export (int) var SPEED
var velocity = Vector2()
var screensize

func _ready():
	screensize = get_viewport_rect().size
	#hide()

func _process(delta):
	$Light2D.energy = $Light2D.energy + rand_range(-0.1, 0.1)
	if $Light2D.energy < 0.2:
		$Light2D.energy = 0.2
	elif $Light2D.energy  > 0.5:
		$Light2D.energy  = 0.5
	
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		#$AnimatedSprite.play()
	else:
		#$AnimatedSprite.stop()
		pass
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.disabled = true
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
