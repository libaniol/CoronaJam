extends TileMap

signal take

func take_item(item : Node2D):
	emit_signal("take", item)
