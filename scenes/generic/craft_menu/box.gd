extends VBoxContainer

signal selected

func item_selected(button):
	emit_signal("selected", button)
