extends Node

export (PackedScene) var Mob
export (PackedScene) var Bullet

var score
var touch_position = Vector2()

# var to bullet and shoot
var drag_speed = 50
var start_line_position = Vector2()
var end_line_position = Vector2()


func _ready():
	randomize()
	
func _physics_process(delta):
	if touch_position.x > 0:
		kill_mob()
			
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_position = event.position
		else:
			if start_line_position != Vector2() and end_line_position != Vector2() and start_line_position != end_line_position:
				shoot()
			else:
				start_line_position = Vector2()
				end_line_position = Vector2()
	elif event is InputEventScreenDrag:
		if event.relative.x > drag_speed or event.relative.x < -1*drag_speed or event.relative.y > drag_speed or event.relative.y < -1*drag_speed:
			if start_line_position == Vector2():
				start_line_position = event.position 
				end_line_position = event.position
			else:
				end_line_position = event.position

func kill_mob():
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_point(touch_position, 1, [], 2)
		if result.size() > 0:
			var f = result.front()
			if f.collider.name.find("Mob") >= 0:
				f.collider.kill()
		touch_position = Vector2()

func shoot():
	var bullet = Bullet.instance()
	var dir = (end_line_position - start_line_position).normalized()
	bullet.start_at(dir, end_line_position)
	add_child(bullet)
	start_line_position = Vector2()
	end_line_position = Vector2()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/60, PI/60)
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))


func _on_OufOfArea_body_entered(body):
	print("kill")
	body.queue_free()
