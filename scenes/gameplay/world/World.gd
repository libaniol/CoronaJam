extends Node2D

signal inspect
signal collect
signal toggle_menu

var item : Node2D = null

var menu_item_scene : PackedScene = preload("res://scenes/generic/item_menu/item_menu.tscn")
var menu_active : bool = false


func _on_grid_pressed(p_item : Node2D):
	if !menu_active:
		var menu = menu_item_scene.instance()
		menu.inspect = p_item.inspect
		menu.use = p_item.use
		menu.collect = p_item.collect
		item = p_item
		add_child(menu)
		emit_signal("toggle_menu")
		menu_active = true



func _on_Inspect_pressed():
	emit_signal("inspect")
	item = null



func _on_Use_pressed():
	item.use_item()
	item = null



func _on_Collect_pressed():
	emit_signal("collect", item)
	item = null


func _on_gui_destroyed():
	emit_signal("toggle_menu")
	menu_active = false



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$gui/gui.hide()
		item = null
	pass
