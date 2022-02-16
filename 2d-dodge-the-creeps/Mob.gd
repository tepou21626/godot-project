extends RigidBody2D


export var min_speed = 150.0
export var max_speed = 250.0


# Method called when game is launched.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


# Method called when mob quits screen.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# Method called when mob hitbox is penetrated.
func _on_hitbox_body_entered(body):
	if body.is_in_group("lethal"):
		queue_free()
