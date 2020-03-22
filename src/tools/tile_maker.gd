tool

extends Node2D

export var horizontal_size : int
export var vertical_size : int
export var run_on_load : bool
export var clear_on_load : bool
export var tile : int

onready var ground : TileMap = $ground

func _ready():
	if run_on_load:
		if clear_on_load:
			ground.clear()
		for i in range(-horizontal_size, horizontal_size):
			for j in range(-vertical_size, vertical_size):
				ground.set_cell(i, j, tile)
	pass
