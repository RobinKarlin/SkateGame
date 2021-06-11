extends StaticBody2D

onready var player = get_node("/root/MainScene/Player")
onready var grind = false

func _ready():
	$StaticCollider.disabled = true


func _process(delta):
	if player.grinding:
		if player.motion.x > 0:
			$StaticCollider.disabled = false
	#Fall off rail if speed is zero
	if not player.grinding or player.motion.x <= 0:
		$StaticCollider.disabled = true
	
