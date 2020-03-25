extends CanvasLayer


signal craft


func _on_EXIT_pressed():
	pass # Replace with function body.



func _on_CRAFT_pressed():
	pass # Replace with function body.



func select_item(id : String):
	pass



func _on_pressed(button):
	var character : Character = get_tree().current_scene.get_character() as Character
	
	if character.get_item_qtd(button.material_1) >= button.material_1_qtd:
		if button.material_2 != "none":
			if character.get_item_qtd(button.material_2) >= button.material_2_qtd:
				if button.material_3 != "none":
					if character.get_item_qtd(button.material_3) >= button.material_3_qtd:
						pass
