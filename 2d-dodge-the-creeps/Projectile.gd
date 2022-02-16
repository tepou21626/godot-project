extends RigidBody2D


var speed = 1000
export var direction : Vector2


func _process(delta):
	position += delta * speed * direction


func _on_hitbox_body_entered(body):
	if (body.is_in_group("mobs")):
		queue_free()



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
