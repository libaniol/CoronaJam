extends Node2D

signal take
signal view
signal use

var id : String = "FlowerPot"



func _ready():
	get_node("interactible").get_popup().connect("id_pressed", self, "_on_item_pressed")
	if connect("take", get_parent(), "take_item") != OK:
		get_tree().quit()


func _on_item_pressed(ID):
	match ID:
		0:
			emit_signal("view")
		1:
			emit_signal("take", self)
		2:
			emit_signal("use")
