extends Node2D

var taken = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("GameState", "scraps_up")
		queue_free()
	
