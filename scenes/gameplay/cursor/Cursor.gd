extends Node2D

signal click
signal use
signal take_item

enum CursorStates {
	NONE,
	CROSS,
	INTERACT,
	PLACE
}

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var grid : TileMap = get_tree().current_scene.get_node("World").get_node("grid") as TileMap

var state = CursorStates.CROSS
var current_item : PackedScene = null
var items : Dictionary



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_json()



func _process(_delta):
	var mouse_pos : Vector2 = get_global_mouse_position()
	position = mouse_pos
	
	match state:
		CursorStates.CROSS:
			sprite.play("default")
			if Input.is_action_just_pressed("attack"):
				emit_signal("click")
		CursorStates.INTERACT:
			sprite.play("interact")
		CursorStates.PLACE:
			if Input.is_action_just_pressed("attack"):
				emit_signal("use", self)
		CursorStates.NONE:
			state = CursorStates.CROSS



func take_item(item : Node2D):
	emit_signal("take_item", item, self)



func equip_item(item : int):
	if item >= 0:
		state = CursorStates.PLACE
	else:
		state = CursorStates.CROSS



func _on_Area2D_area_entered(area):
	if state == CursorStates.CROSS:
		if area.is_in_group("interactible"):
			state = CursorStates.INTERACT



func _on_Area2D_area_exited(area):
	if state == CursorStates.INTERACT:
		if area.is_in_group("interactible"):
			state = CursorStates.NONE



func use_item_process(id : String, character):
	var path : String = "res://scenes/gameplay/grid_items/" + items[id].scene
	var item : PackedScene = load(path)
	
	var coord : Vector2 = grid.world_to_map(position)
	
	var cell : int = grid.get_cellv(coord)
	
	if cell < 0:
		var pos : Vector2 = grid.map_to_world(coord) + Vector2(16.0, 16.0)
		
		var instance : Node2D = item.instance()
		instance.position = pos
		
		grid.add_child(instance)
		grid.set_cellv(coord, 0)
		character.bag_qnt[character.current_item] -= 1



func take_item_process(item : Node2D):
	var coord : Vector2 = grid.world_to_map(item.position)
	
	grid.set_cellv(coord, -1)



func load_json():
	var item_file : File = File.new()
	if item_file.open("res://data/json/grid_items/grid_items.json", File.READ) != OK:
		return
	var data_text = item_file.get_as_text()
	item_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	items = data_parse.result
