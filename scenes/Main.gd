extends Node

export (PackedScene) var Mob
export (PackedScene) var BigMob
export (PackedScene) var Bullet
export (PackedScene) var MobDead
export (PackedScene) var Points

var score
var touch_position = Vector2()
var drag_player = false
var points = 0

# var to bullet and shoot
var drag_speed = 30
var start_line_position = Vector2()
var end_line_position = Vector2()


func _ready():
	$StartPosition.position.x = get_viewport_rect().size.x/2
	$StartPosition.position.y = get_viewport_rect().size.y/5 * 4
	randomize()
	
func _physics_process(delta):
	if touch_position.x > 0:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_point(touch_position, 1, [], 1)
		if result.size() > 0:
			var f = result.front()
			print (f.collider.name)
			if f.collider.name.find("BigMobArea") >= 0:
				f.collider.get_parent().kill(touch_position)
			elif f.collider.name.find("BigMob") >= 0:
				f.collider.kill(touch_position)
			elif f.collider.name.find("Mob") >= 0:
				f.collider.kill()
			elif f.collider.name == "Player":
				drag_player = true
				
		touch_position = Vector2()
			
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_position = event.position
		else:
			drag_player = false
			if start_line_position != Vector2() and end_line_position != Vector2() and start_line_position != end_line_position:
				shoot()
			else:
				start_line_position = Vector2()
				end_line_position = Vector2()
	elif event is InputEventScreenDrag:
		if drag_player:
			$Player.position = event.position
		elif event.relative.x > drag_speed or event.relative.x < -1*drag_speed or event.relative.y > drag_speed or event.relative.y < -1*drag_speed:
			if start_line_position == Vector2():
				start_line_position = event.position 
				end_line_position = event.position
			else:
				end_line_position = event.position

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
	points = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$BigMobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 0.1
	$HUD.update_score(score)

func _on_BigMobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = BigMob.instance()
	add_child(mob)
	mob.connect("boom", self, "explode")
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/60, PI/60)
	#mob.rotation = direction
#	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))
	

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	mob.connect("boom", self, "explode")
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/60, PI/60)
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))

func explode(_position):
	var mob_dead = MobDead.instance()
	mob_dead.position = _position + Vector2(0, 10)
	points += 50
	$HUD.update_points(points)
	add_child(mob_dead)
	
	var score_label = Points.instance()
	score_label.position = _position
	score_label.set_text("50 points!")
	add_child(score_label)
	

func _on_OufOfArea_body_entered(body):
	#body.queue_free()
	pass
