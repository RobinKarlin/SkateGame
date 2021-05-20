extends KinematicBody2D

onready var player = get_parent().get_node("Player")
#onready var stomp_area: Area2D = $StompArea2D

export var score: = 100

var grav = 1800
var vel = Vector2(0, 0)
var max_grav = 3000
var state_machine
var react_time = 1200
var dir = 0
var next_dir = 0
var next_dir_time = 0

#func _ready() -> void:
#	set_physics_process(false)
#	_velocity.x = -speed.x

func _ready():
	set_process(true)
	state_machine = $AnimationTree.get("parameters/playback")
	

func _process(delta):
	var current = state_machine.get_current_node()
	if player.position.x < position.x and next_dir != -1:
		next_dir = -1
		next_dir_time = OS.get_ticks_msec() + react_time
	elif player.position.x > position.x and next_dir != 1:
		next_dir = 1
		next_dir_time = OS.get_ticks_msec() + react_time
	elif player.position.x == position.x and next_dir != 0:
		next_dir = 0
		next_dir_time = OS.get_ticks_msec() + react_time
		
	if OS.get_ticks_msec() >  next_dir_time:
		dir = next_dir
	
	#enemy Direction
	if vel.x < 0:
		player.flip_h = true
	elif vel.x > 0:
		player.flip_h = false
	if vel.length() == 0:
		state_machine.travel("Idle")
	if vel.length() > 0:
		state_machine.travel("Run")
		
	vel.x = dir * 500
	
	
	vel.y += grav * delta;
	if vel.y > max_grav:
		vel.y = max_grav
	
	if is_on_floor() and vel.y > 0:
		vel.y = 0
	vel = move_and_slide(vel, Vector2(0, 1))
