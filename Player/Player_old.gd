extends KinematicBody2D

onready var just_aired_timer : Timer = $JustAiredTimer
onready var fell_down_timer : Timer = $FellDownTimer

var motion = Vector2(0,0)
var grinding = false
var pushforce = 2
var JustAired = false
var FloorNormal = Vector2(0, -1)
var fell_down = false
var hitting_rail = false

const SPEED = 400
const PUSHSPEED = 75
const SLOWDOWN = 1
const MAXSPEED = 375
const WORLD_LIMIT = 3500
const GRAVITY = 20
const UP = Vector2(0,-1)
const FLOOR_NORMAL = Vector2.UP
const JUMP_SPEED = GRAVITY + 500




func _physics_process(delta):
	
	motion.y += GRAVITY * delta
	motion = move_and_slide(motion, FLOOR_NORMAL)
	apply_gravity()
	jump()
	move()	
	attack()
#	landing()
	move_and_slide(motion, FLOOR_NORMAL, false, 4, PI/4, false)
	colliding()
	reset_game()
	grinding()
	if fell_down:
		falling_down()
	
	
	
	
	
	


func reset_game():
	if Input.is_action_just_pressed("reset_game"):
		get_tree().change_scene("res://Scenes/MainScene.tscn")


#	Collide with rigid body and give it a push * player speed
func colliding():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("props"):
			collision.collider.apply_central_impulse(-collision.normal * (motion/10).length() * pushforce)
			collision.collider.apply_central_impulse(collision.normal * (pushforce+10))


func apply_gravity():
	
	if is_on_floor() and $RayCast2D.is_colliding():
		motion.y = 0		
	else:
		motion.y += GRAVITY
	if is_on_ceiling():
		motion.y = 1
	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
	


# does not work right now
#func landing():	
#	if get_floor_normal() == FloorNormal:
#		if Input.is_action_just_pressed("ollie"):
#			just_aired_timer.start()
#		if just_aired_timer.is_stopped() and !is_on_floor():
#			JustAired = true
#		if is_on_floor() and JustAired:
#			motion.x += 5 * motion.x / 4
#			JustAired = false


func grinding():	
	if Input.is_action_pressed("grind"):
		if not is_on_floor():
			$AnimatedSprite.play("Grinding")
			grinding = true
	else:
		$AnimatedSprite.play("Idle")
		grinding = false
	
#	if hitting_rail:
#		motion.x += 5
	
#		if grinding and is_on_floor():
#			fell_down_timer.start()
#			fell_down = true
#			grinding = false
	



func falling_down():
	if fell_down:
		$AnimatedSprite.play("Falling")
		if motion.x > 0:
			motion.x -= 20
	if fell_down_timer.is_stopped():
		fell_down = false
		if not fell_down and motion.x <= 0:
			$AnimatedSprite.play("Idle")



func jump():
	if Input.is_action_pressed("ollie") and is_on_floor() and not fell_down:
		motion.y -= JUMP_SPEED


func move():
	var SpeedLevel = MAXSPEED / 2
	if Input.is_action_just_pressed("left"):
		if motion.x != -MAXSPEED:
			if motion.x > -SpeedLevel:
				motion.x -= PUSHSPEED
			if motion.x > -SpeedLevel * 2:
				motion.x -= PUSHSPEED
			if motion.x > 0:
				motion.x -= SLOWDOWN * 2
#	Increase speed right
	if Input.is_action_just_pressed("push") and not grinding and not fell_down:
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


func attack():
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("Attack")


func _on_AttackArea2d_area_entered(area):
	if area.is_in_group("props"):
		area.get_parent().getting_hit()





func _on_GrindingArea2d_area_entered(area):
	hitting_rail = true
	
	


func _on_GrindingArea2d_area_exited(area):
	hitting_rail = false
