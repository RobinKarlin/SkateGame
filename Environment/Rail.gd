extends StaticBody2D

onready var player = get_node("/root/MainScene/Player")
onready var grind = false

func _ready():
	$StaticCollider.disabled = true


func _process(delta):
	if player.grinding and player.motion.x > 0:
		$StaticCollider.disabled = false
	#Fall off rail if speed is zero
	if player.motion.x <= 0 and grind:
		$StaticCollider.disabled = true


#Variable enable when actually being on the rail
func _on_Area2DOnRail_area_entered(area):
	grind = true

	

#Variable turn off when not being on the rail anymore
func _on_Area2DOnRail_area_exited(area):
	grind = false
	
