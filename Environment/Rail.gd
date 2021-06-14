extends StaticBody2D

onready var player = get_node("/root/MainScene/Player")
onready var grind

func _ready():
	$StaticCollider.disabled = true

func _process(delta):
#	print(grind)
	if grind:
		if player.motion.x > 0:
			$StaticCollider.disabled = false
	#Fall off rail if speed is zero
	if not grind or player.motion.x <= 0:
		$StaticCollider.disabled = true
	
