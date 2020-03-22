extends Node2D

signal take

func take_item(item : Node2D):
	emit_signal("take", item)
