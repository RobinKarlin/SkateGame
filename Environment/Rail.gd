extends StaticBody2D

onready var player = get_node("/root/MainScene/Player")
onready var grind


func _ready():
	$StaticCollider.disabled = true

func _process(delta):
	if grind:
		if player.motion.x > 0:
			$StaticCollider.disabled = false
			
	#Fall off rail if speed is zero
	if not grind or player.motion.x <= 0:
		$StaticCollider.disabled = true
		
	if player.hitting_rail and not player.grinding and not Input.is_action_pressed("ollie"):
		$StaticCollider.disabled = true
		player.fell_down_timer.start()
		player.fell_down = true
	
