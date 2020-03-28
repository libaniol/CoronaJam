extends Control

onready var container = $HBoxContainer

onready var items : Dictionary = load_json()

func _on_Character_acquire(index : int, qnt : int):
	var ind : TextureButton = container.get_node("item_0" + str(index)) as TextureButton
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)



func _on_Character_add(index : int, qnt : int, _id : String):
	var ind : TextureButton = container.get_node("item_0" + str(index)) as TextureButton
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)
	var texture : Texture = load("res://resources/textures/icons/" + items[_id].icon)
	ind.get_node("TextureRect").texture = texture
	



func _on_Character_use(index : int, qnt : int):
	var ind : TextureButton = container.get_node("item_0" + str(index)) as TextureButton
	var lbl : Label = ind.get_node("qnt") as Label
	lbl.text = str(qnt)
	if qnt == 0:
		ind.get_node("TextureRect").texture = null



func load_json():
	var item_file : File = File.new()
	if item_file.open("res://data/json/icons/icon.json", File.READ) != OK:
		return
	var data_text = item_file.get_as_text()
	item_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	return data_parse.result
