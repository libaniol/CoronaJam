extends Node2D

class_name GridItem

signal pressed

export var id : String = "none"
export var qtd : int = 1
export(String, MULTILINE) var inspect_text : String
export var inspect : bool
export var use : bool
export var collect : bool

var coord : Vector2

func _ready():
	if get_node("interactible").connect("pressed", self, "_on_pressed") != OK:	get_tree().quit()
	if connect("pressed", get_parent(), "_on_item_pressed") != OK:	get_tree().quit()

func remove():
	qtd -= 1
	if qtd == 0:
		queue_free()


func _on_pressed():
	emit_signal("pressed", self)


func _exit_tree():
		var grid : TileMap = get_parent() as TileMap
		grid.set_cellv(coord, grid.get_cellv(coord) - 1)
