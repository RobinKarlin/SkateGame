extends KinematicBody2D

var motion = Vector2(0,0)
var grinding = false
const SPEED = 400
const PUSHSPEED = 75
const SLOWDOWN = 1
const MAXSPEED = 375
const WORLD_LIMIT = 3500
const GRAVITY = 25
const UP = Vector2(0,-1)
const JUMP_SPEED = GRAVITY + 500


func _physics_process(delta):
	apply_gravity()
	jump()
	move()
	move_and_slide(motion, UP)
#	get_slide_collision(50)
	print(motion)
	print("hej")
	


func apply_gravity():
	if is_on_floor() and motion.y > 0:
		motion.y = 0
	else:
		motion.y += GRAVITY
	if is_on_ceiling():
		motion.y = 1


func jump():
	if Input.is_action_pressed("ollie") and is_on_floor():
		motion.y -= JUMP_SPEED



func grind():	
	motion.x += 10 + motion.x
	if grinding != true:
		grinding = true
	else:
		grinding = false
	
	

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
	if Input.is_action_just_pressed("right"):
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



func reset_game():
	if Input.is_action_pressed("reset_game"):
		get_tree().reload_current_scene()
		
	



func _on_Rail_body_entered(body):
	grind()
