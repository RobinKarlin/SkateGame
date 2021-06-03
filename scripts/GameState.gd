extends Node2D

var scraps = 0

func _ready():
	add_to_group("GameState")
	update_GUI()


func scraps_up():
	scraps += 1
	update_GUI()


func update_GUI():
	get_tree().call_group("GUI", "update_gui", scraps)
	




