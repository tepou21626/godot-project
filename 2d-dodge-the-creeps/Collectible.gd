extends RigidBody2D


# Method that creates special effect when collected.
func pickup():
	queue_free()
