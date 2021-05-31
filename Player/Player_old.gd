extends KinematicBody2D

onready var just_aired_timer : Timer = $JustAiredTimer

var motion = Vector2(0,0)
var grinding = false
var pushforce = 5
var JustAired = false
var FloorNormal = Vector2(0, -1)

const SPEED = 400
const PUSHSPEED = 75
const SLOWDOWN = 1
const MAXSPEED = 375
const WORLD_LIMIT = 3500
const GRAVITY = 20
const UP = Vector2(0,-1)
const FLOOR_NORMAL = Vector2.UP
const JUMP_SPEED = GRAVITY + 500

func reset_game():
	if Input.is_action_just_pressed("reset_game"):
		get_tree().change_scene("res://Scenes/MainScene.tscn")



func _physics_process(delta):	
	motion.y += GRAVITY * delta
	motion = move_and_slide(motion, FLOOR_NORMAL)
	apply_gravity()
	jump()
	move()
	landing()
	move_and_slide(motion, FLOOR_NORMAL, false, 4, PI/4, false)

#	Collide with rigid body and give it a push * player speed
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * (motion/7).length() * pushforce)
			collision.collider.apply_central_impulse(collision.normal * pushforce)
			
	

func apply_gravity():	
	if is_on_floor() and $RayCast2D.is_colliding():
		motion.y = 0		
	else:
		motion.y += GRAVITY
	if is_on_ceiling():
		motion.y = 1
	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
#	if is_on_wall():
#		motion.x = 0


func landing():	
	if get_floor_normal() == FloorNormal:
		if Input.is_action_just_pressed("ollie"):
			just_aired_timer.start()
		if just_aired_timer.is_stopped() and !is_on_floor():
			JustAired = true
		if is_on_floor() and JustAired:
			motion.x += 1.5 * motion.x / 4
			JustAired = false
		print(JustAired)
	



func jump():
	if Input.is_action_pressed("ollie") and is_on_floor():
		motion.y -= JUMP_SPEED


#func IsOnSlope():
#	if get_floor_normal().angle() != 0 :
#		motion.x -= 5
	


#func grind():
#	if Input.is_action_just_pressed("grind"):
#		grinding = true
#	else:
#		grinding = false
#	motion.x += 10 + motion.x
	

func move():
	var SpeedLevel = MAXSPEED / 2	
#	Increase speed left

	if Input.is_action_just_pressed("left"):
		if motion.x != -MAXSPEED:
			if motion.x > -SpeedLevel:
				motion.x -= PUSHSPEED
			if motion.x > -SpeedLevel * 2:
				motion.x -= PUSHSPEED
			if motion.x > 0:
				motion.x -= SLOWDOWN * 2				
#	Increase speed right
	if Input.is_action_just_pressed("push"):
		if motion.x != MAXSPEED:
			if motion.x < SpeedLevel:
				motion.x += PUSHSPEED
			if motion.x < SpeedLevel * 2:
				motion.x += PUSHSPEED
			if motion.x < 0:
				motion.x += SLOWDOWN * 2
#	Slowing down left		
	if motion.x != 0:
		if motion.x < 0:
			motion.x += SLOWDOWN
#	Slowing down right
		if motion.x > 0:
			motion.x -= SLOWDOWN
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		motion.x = 0








