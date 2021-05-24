extends RigidBody2D

onready var just_aired_timer : Timer = $JustAiredTimer
onready var _transitions: = {
		IDLE: [MOVING, AIR],
		MOVING: [IDLE, AIR],
		AIR: [MOVING, IDLE],	
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

const SLOWDOWN = 1
const MAXSPEED = 200.0

var _state: int = IDLE

#onready var back_wheel = get_node("BackWheel")
#onready var front_wheel = get_node("FrontWheel")

func _integrate_forces(state: Physics2DDirectBodyState):
	var is_on_ground := state.get_contact_count() > 0 and int(state.get_contact_collider_position(0).y) >= int(global_position.y)
	var move_direction = moving()
	
	print(_state)
	
	
	match _state:
		IDLE:
			if move_direction.x:
				change_state(MOVING)
			if is_on_ground and Input.is_action_just_pressed("ollie"):
				apply_impulse(jump_force_offset, jump_force)	
				change_state(AIR)
				
		
		MOVING:			
			if state.linear_velocity.x == 0.0 and move_direction.x == 0.0:
				change_state(IDLE)
			if state.get_contact_count() == 0:
				change_state(AIR)
			elif is_on_ground and Input.is_action_just_pressed("ollie"):
				apply_impulse(jump_force_offset, jump_force)
				change_state(AIR)
			elif is_on_ground and Input.is_action_just_pressed("push"):
				apply_impulse(push_force_offset, push_force)

			

		AIR:
			if move_direction and not is_on_ground:
				state.linear_velocity.x += air_speed
			if state.linear_velocity.x and just_aired_timer.is_stopped():
				change_state(IDLE)
			if state.linear_velocity.x:
				change_state(MOVING)
				
				
	



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


func moving():
	return Vector2(Input.is_action_just_pressed("push"), 0)
#		move_direction += 3
#	if move_direction > 0:
#		move_direction -= SLOWDOWN
		
