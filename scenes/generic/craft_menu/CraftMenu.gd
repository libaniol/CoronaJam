extends CanvasLayer


signal craft

var item : String = ""
var qtd : int = 0

onready var icons : Dictionary = load_json()



func _on_EXIT_pressed():
	queue_free()



func _on_CRAFT_pressed():
	emit_signal("craft", item, qtd)



func selected(button):
	item = button.item_id
	qtd = button.item_qtd
	
	var material_1_texture : Texture = null
	var material_2_texture : Texture = null
	var material_3_texture : Texture = null
	
	var item_texture : Texture = load("res://resources/textures/icons/" + icons[item].icon)
	$Control/menu_panel/craft/item/icon.texture = item_texture
	if button.material_1 != "none":
		material_1_texture = load("res://resources/textures/icons/" + icons[button.material_1].icon)
	$Control/menu_panel/craft/material/materials/material1/texture.texture = material_1_texture
	if button.material_2 != "none":
		material_2_texture = load("res://resources/textures/icons/" + icons[button.material_2].icon)
	$Control/menu_panel/craft/material/materials/material2/texture.texture = material_2_texture
	if button.material_3 != "none":
		material_3_texture = load("res://resources/textures/icons/" + icons[button.material_2].icon)
	$Control/menu_panel/craft/material/materials/material3/texture.texture = material_3_texture

func _on_pressed(button):
	var character : Character = get_tree().current_scene.get_character() as Character
	
	if button.material_1 != "none":
		if character.get_item_qtd(button.material_1) >= button.material_1_qtd:
			$Control/menu_panel/craft/material/materials/material1.self_modulate = Color(0, 0.5, 0, 1)
			$Control/CRAFT.disabled = false
		else:
			$Control/menu_panel/craft/material/materials/material1.self_modulate = Color(0.5, 0, 0, 1)
			$Control/CRAFT.disabled = true
	if button.material_2 != "none":
		if character.get_item_qtd(button.material_2) >= button.material_2_qtd:
			$Control/menu_panel/craft/material/materials/material2.self_modulate = Color(0, 0.5, 0, 1)
			$Control/CRAFT.disabled = false
		else:
			$Control/menu_panel/craft/material/materials/material2.self_modulate = Color(0.5, 0, 0, 1)
			$Control/CRAFT.disabled = true
	if button.material_3 != "none":
		if character.get_item_qtd(button.material_3) >= button.material_3_qtd:
			$Control/menu_panel/craft/material/materials/material3.self_modulate = Color(0, 0.5, 0, 1)
			$Control/CRAFT.disabled = false
		else:
			$Control/menu_panel/craft/material/materials/material3.self_modulate = Color(0.5, 0, 0, 1)
			$Control/CRAFT.disabled = true
	selected(button)



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
