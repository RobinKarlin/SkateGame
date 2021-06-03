extends CanvasLayer


func update_gui(scraps_added):
	$Control/TextureRect/HBoxContainer/LabelCurrency/CurrencyCount.text = str(scraps_added)
	
