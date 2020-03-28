extends GridItem


onready var craft_menu : PackedScene = preload("res://scenes/generic/craft_menu/CraftMenu.tscn")


func _process(_delta):
	pass

func use_item():
	var menu = craft_menu.instance()
	add_child(menu)
