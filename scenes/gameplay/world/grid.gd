extends TileMap

signal pressed

func _on_item_pressed(item : Node2D):
	emit_signal("pressed", item)
