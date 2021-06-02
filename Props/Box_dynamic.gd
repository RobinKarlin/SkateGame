extends RigidBody2D

const ForceX = 100
const ForceY = 200
const UP = Vector2(ForceX,-1*ForceY)
const FLOOR_NORMAL = Vector2.UP

func getting_hit():
	apply_central_impulse(UP)
