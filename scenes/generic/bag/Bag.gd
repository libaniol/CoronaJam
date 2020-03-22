extends Control

onready var container = $HBoxContainer



func _on_Character_acquire(index : int, qnt : int):
	var ind = container.get_node("item_0" + str(index))
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)



func _on_Character_add(index : int, qnt : int, _id : String):
	var ind = container.get_node("item_0" + str(index))
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)



func _on_Character_use(index : int, qnt : int):
	var ind = container.get_node("item_0" + str(index))
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)
