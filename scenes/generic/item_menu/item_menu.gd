extends CanvasLayer

signal destroyed
signal use_pressed
signal inspect_pressed
signal collect_pressed

var destroy : bool = false

var inspect : bool
var use : bool
var collect : bool

func _ready():
	if connect("destroyed", get_parent(), "_on_gui_destroyed") != OK:	get_tree().quit()
	if connect("use_pressed", get_parent(), "_on_Use_pressed") != OK:	get_tree().quit()
	if connect("inspect_pressed", get_parent(), "_on_Inspect_pressed") != OK:	get_tree().quit()
	if connect("collect_pressed", get_parent(), "_on_Collect_pressed") != OK:	get_tree().quit()
	
	$gui/ui/menu/Collect.disabled = !collect
	$gui/ui/menu/Inspect.disabled = !inspect
	$gui/ui/menu/Use.disabled = !use



func _process(_delta):
	if destroy:
		queue_free()
	if Input.is_action_just_pressed("attack"):
		emit_signal("destroyed")
		destroy = true



func _on_Use_pressed():
	emit_signal("use_pressed")
	queue_free()



func _on_Collect_pressed():
	emit_signal("collect_pressed")
	queue_free()



func _on_Inspect_pressed():
	emit_signal("inspect_pressed")
	queue_free()



func _exit_tree():
	emit_signal("destroyed")
