extends Button

export var item_id : String = "empty"
export var item_qtd : int = 0

export var material_1 : String = "none"
export var material_2 : String = "none"
export var material_3 : String = "none"

export var material_1_qtd : int = 10
export var material_2_qtd : int = 10
export var material_3_qtd : int = 10



func _ready():
	if connect("pressed", self, "_on_pressed") != OK:
		get_tree().quit()



func _on_pressed():
	get_parent().item_selected(self)
