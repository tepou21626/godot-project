extends Area2D

signal died
signal hit
signal shoot
signal pickup


export var speed = 400.0
var screen_size = Vector2.ZERO

export var orientation = "right"

# Lives property.
const DEFAULT_LIVES_COUNT: int = 3
var lives = 3


# Shooting mecanics.
var can_shoot


# Method called when game is launched.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	can_shoot = false


# Method called each frame to compute new positions and inputs.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		orientation = "right"
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		orientation = "left"
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		orientation = "down"
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		orientation = "up"
		
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += direction * speed * delta
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = direction.x < 0
		$AnimatedSprite.flip_v = false
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
		
	if Input.is_action_pressed("shoot") and can_shoot:
		emit_signal("shoot", position, orientation)
		can_shoot = false
		$ShootTimer.start()
		
		
# Method called when game starts.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func start(new_position):
	position = new_position
	lives = DEFAULT_LIVES_COUNT
	show()
	$CollisionShape2D.disabled = false
	can_shoot = true


# Method called when body penetrates player.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_Player_body_entered(body):
	if (body.is_in_group("mobs")):
		update_lives_count(lives - 1)
		if lives == 0:	
			hide()
			$CollisionShape2D.set_deferred("disabled", true)
			can_shoot = false
			$ShootTimer.stop()
			emit_signal("died")
	elif (body.is_in_group("collectible")):
		body.pickup()
		on_gain_life()


# Method called to update amount of livess.
func update_lives_count(lives_count):
	lives = lives_count
	emit_signal("hit", lives)
	


# Method called when reloading is done.
func _on_ShootTimer_timeout():
	can_shoot = true


# Method called when food is eaten.
func on_gain_life():
	update_lives_count(min(lives + 1, DEFAULT_LIVES_COUNT))
