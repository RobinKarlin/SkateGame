extends RigidBody2D

onready var just_aired_timer : Timer = $JustAiredTimer
onready var _transitions: = {
		IDLE: [MOVING, AIR],
		MOVING: [IDLE, AIR],
		AIR: [IDLE],	
	}

enum {
	IDLE,
	MOVING,
	AIR,
	
}

var state_strings: = {
	IDLE: "idle",
	MOVING: "moving",
	AIR: "air",	
}


const FLOOR_NORMAL := Vector2.UP
export var move_speed = 400
export var air_speed = 100.0
export var jump_force := Vector2(0,-1200)
var jump_force_offset := Vector2(-40,0)
export var push_force := Vector2(5000,0)
var push_force_offset := Vector2(-30,-5)
const MAXSPEED = 200.0

var _state: int = IDLE

#onready var back_wheel = get_node("BackWheel")
#onready var front_wheel = get_node("FrontWheel")

func _integrate_forces(state: Physics2DDirectBodyState):
	var is_on_ground := state.get_contact_count() > 0 and int(state.get_contact_collider_position(0).y) >= int(global_position.y)
	
	var move_direction := get_move_direction()
#	print(player_rot)
	
	
	
	match _state:
		IDLE:
			if move_direction.x:
				change_state(MOVING)
			if is_on_ground and Input.is_action_just_pressed("ollie"):
				apply_impulse(jump_force_offset, jump_force)	
				change_state(AIR)
		
		MOVING:			
			if not move_direction.x:
				change_state(IDLE)
			elif state.get_contact_count() == 0:
				change_state(AIR)
			elif is_on_ground and Input.is_action_just_pressed("ollie"):
				apply_impulse(jump_force_offset, jump_force)
				change_state(AIR)
			apply_impulse(push_force_offset, push_force)

		AIR:
			if move_direction.x:
				state.linear_velocity.x += move_direction.x * air_speed
			if is_on_ground and just_aired_timer.is_stopped():
				change_state(IDLE)
				
	



func change_state(target_state: int) -> void:
	if not target_state in _transitions[_state]:
		return
	_state = target_state
	enter_state()



func enter_state():
	match _state:
		IDLE:
			linear_velocity.x = 0
		AIR:
			just_aired_timer.start()
		_:
			return


func get_move_direction() -> Vector2:
	return Vector2(Input.is_action_just_pressed("right"), 0)

#func _process(delta):
#	if Input.is_action_just_pressed("right"):
#		back_wheel.apply_torque_impulse(5000)
#		front_wheel.apply_torque_impulse(5000)
#	if Input.is_action_just_pressed("ollie"):
#		back_wheel.apply_central_impulse(UP)
#		front_wheel.apply_central_impulse(UP)

#func _physics_process(delta):
##	apply_gravity()
##	jump()
##	move()
##	move_and_slide(motion, UP, false, 44)
##	IsOnSlope()
#	print(rotation)


#
#func apply_gravity():
#	if is_on_floor() and motion.y > 0:
#		motion.y = 0
#		rotation = get_floor_normal().angle() + PI/2		
#	else:
#		motion.y += GRAVITY
#	if is_on_ceiling():
#		motion.y = 1
#	if is_on_wall():
#		motion.x = 0
#
#
#
#func jump():
#	if Input.is_action_pressed("ollie") and is_on_floor():
#		motion.y -= JUMP_SPEED
#
#
##func IsOnSlope():
##	if get_floor_normal().angle() != 0 :
##		motion.x -= 5
#
#
#
#func grind():
#	motion.x += 10 + motion.x
#	if grinding != true:
#		grinding = true
#	else:
#		grinding = false
#
#
#
#func move():
#	var SpeedLevel = MAXSPEED / 2	
##	Increase speed left
#	if Input.is_action_just_pressed("left"):
#		if motion.x != -MAXSPEED:
#			if motion.x > -SpeedLevel:
#				motion.x -= PUSHSPEED
#			if motion.x > -SpeedLevel * 2:
#				motion.x -= PUSHSPEED
#			if motion.x > 0:
#				motion.x -= SLOWDOWN * 2				
##	Increase speed right
#	if Input.is_action_just_pressed("right"):
#		if motion.x != MAXSPEED:
#			if motion.x < SpeedLevel:
#				motion.x += PUSHSPEED
#			if motion.x < SpeedLevel * 2:
#				motion.x += PUSHSPEED
#			if motion.x < 0:
#				motion.x += SLOWDOWN * 2
##	Slowing down left		
#	if motion.x != 0:
#		if motion.x < 0:
#			motion.x += SLOWDOWN
##	Slowing down right
#		if motion.x > 0:
#			motion.x -= SLOWDOWN
#	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
#		motion.x = 0
#
#
#
#func reset_game():
#	if Input.is_action_pressed("reset_game"):
#		get_tree().reload_current_scene()
#		get_floor_normal()
#
#



#func _on_Rail_body_entered(body):
#	grind()
