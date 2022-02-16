extends RigidBody2D


signal gain_life


# Method that creates special effect when collected.
func pickup():

	queue_free()
