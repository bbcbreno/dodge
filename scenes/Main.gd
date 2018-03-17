extends Node

export (PackedScene) var Mob
var score
var touch_position = Vector2()


func _ready():
	randomize()
	
func _physics_process(delta):
#	var space_state = get_world_2d().direct_space_state
#	var result = space_state.intersect_ray(Vector2(150, 150), Vector2(600, 150))
#	if result:
#		print("Hit at collider: ", result.collider)
#		print("Hit at collider_id: ", result.collider_id)
#		print("Hit at rid: ", result.rid)
#		print("Hit at point: ", result.position)
#		print("name: ", result.collider.name)
#		print("---")
#		if result.collider.name.find("Mob") == 1:
#			result.collider.queue_free()
	if touch_position.x > 0:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_point(touch_position, 1, [], 2)
		var f = result.front()
		if f != null:
			print("pow!")
			f.collider.queue_free()
		touch_position = Vector2()
			
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_position = event.position

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
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))
