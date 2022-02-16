extends Node


# Scenes to instanciate.
export (PackedScene) var mob_scene
export (PackedScene) var projectile_scene
export (PackedScene) var food_scene


enum DIRECTIONS { RIGHT, UP, DOWN, LEFT }

var score


# Method called when game is launched.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _ready():
	randomize()
	
	
# Method called new game starts.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	$HUD.show_message("Get ready...")
	
	yield($StartTimer, "timeout")
	
	$ScoreTimer.start()
	$MobTimer.start()
	$ItemTimer.start()
	
	
# Method that resets game.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$ItemTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


# Method called when mob is spawned.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_MobTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var mob = mob_scene.instance()
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)


# Method called when score increases.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


# Method that instanciates projectile.
func shoot(pos, orientation):
	var projectile = projectile_scene.instance()
	
	projectile.position = pos
	projectile.direction = orientationToDirection(orientation)
	
	add_child(projectile)


# Method that converts orientation (index) to direction.
func orientationToDirection(orientation):
	if orientation == "down":
		return Vector2(0, 1)
	elif orientation == "up":
		return Vector2(0, -1)
	elif orientation == "left":
		return Vector2(-1, 0)
	else:
		return Vector2(1, 0)


# Method called when item appears.
func _on_ItemTimer_timeout():
	var x = rand_range(0, ProjectSettings.get("display/window/size/width"))
	var y = rand_range(0, ProjectSettings.get("display/window/size/height"))
	var pos = Vector2(x, y)
	
	var food = food_scene.instance()
	food.position = pos
	add_child(food)
