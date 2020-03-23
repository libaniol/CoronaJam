extends KinematicBody2D

signal acquire
signal add
signal use

signal equip

onready var feet : AnimatedSprite = $Feet/FeetSprite
onready var body : AnimatedSprite = $Body/BodySprite
onready var part : AnimatedSprite = $Part/PartSprite

export var move_speed : float = 0.0
var velocity : Vector2 = Vector2()

var bag : PoolStringArray = [
		"FlowerPot", 
		"empty", 
		"empty", 
		"empty", 
		"empty", 
		"empty", 
		"empty", 
		"empty", 
		"empty", 
		"empty"
]
var bag_qnt : PoolIntArray = [
		9, 
		0, 
		0, 
		0, 
		0, 
		0, 
		0, 
		0, 
		0, 
		0
]
var current_item : int = -1
export var bag_limit : int = 10

enum FeetStates {
	IDLE,
	WALK,
}

enum BodyStates {
	IDLE,
	WALK,
	ATTACK
}

var feet_state : int = FeetStates.IDLE
var body_state : int = BodyStates.IDLE



func _ready():
	pass



func _process(_delta) -> void:
	match body_state:
		BodyStates.IDLE:
			equipment_input()
			body.play("idle")
			if move_input_process():
				body_state = BodyStates.WALK
			continue
		BodyStates.WALK:
			equipment_input()
			body.play("walk")
			if not move_input_process():
				body_state = BodyStates.IDLE
			continue
		BodyStates.ATTACK:
			equipment_input()
			body.play("attack")
			part.get_parent().show()
			part.play("punch")
			# warning-ignore:return_value_discarded
			move_input_process()
			continue
	
	match feet_state:
		FeetStates.IDLE:
			feet.play("idle")
		FeetStates.WALK:
			feet.play("walk")



func _physics_process(_delta) -> void:
	velocity = move_and_slide(velocity)



func equipment_input():
	if Input.is_action_just_pressed("unequip"):
		emit_signal("equip", -1)
		current_item = -1
	
	if Input.is_key_pressed(KEY_1):
		emit_equip(0)
	if Input.is_key_pressed(KEY_2):
		emit_equip(1)
	if Input.is_key_pressed(KEY_3):
		emit_equip(2)
	if Input.is_key_pressed(KEY_4):
		emit_equip(3)
	if Input.is_key_pressed(KEY_5):
		emit_equip(4)
	if Input.is_key_pressed(KEY_6):
		emit_equip(5)
	if Input.is_key_pressed(KEY_7):
		emit_equip(6)
	if Input.is_key_pressed(KEY_8):
		emit_equip(7)
	if Input.is_key_pressed(KEY_9):
		emit_equip(8)
	if Input.is_key_pressed(KEY_0):
		emit_equip(9)



func emit_equip(equipment : int):
	if bag[equipment] != "empty":
		emit_signal("equip", equipment)
		current_item = equipment



func move_input_process() -> bool:
	var mouse_pos : Vector2 = get_global_mouse_position()
	look_at(mouse_pos)
	
	var movement := Vector2()
	
	if Input.is_action_pressed("move_fw"):
		movement.x += 1.0
	if Input.is_action_pressed("move_bw"):
		movement.x -= 1.0
	if Input.is_action_pressed("move_lf"):
		movement.y += 1.0
	if Input.is_action_pressed("move_rt"):
		movement.y -= 1.0
	
	if movement.length() != 0.0:
		feet_state = FeetStates.WALK
	else:
		feet_state = FeetStates.IDLE
	
	velocity = movement.rotated(rotation) * move_speed
	
	if movement.length() != 0.0:
		return true
	else:
		return false



func get_hit():
	$Animation.play("get_hit")


func acquire_item(id : Node2D, cursor : Node2D):
	var done : bool = false
	for i in range(bag.size()):
		if bag[i] == id.id:
			if bag_qnt[i] < bag_limit:
				bag_qnt[i] += 1
				done = true
				emit_signal("acquire", i, bag_qnt[i])
				id.queue_free()
				cursor.take_item_process(id)
				break
	
	if not done:
		for i in range(bag.size()):
			if bag[i] == "empty":
				bag[i] = id.id
				bag_qnt[i] = 1
				done = true
				emit_signal("add", i, bag_qnt[i], id.id)
				id.queue_free()
				cursor.take_item_process(id)
				break
	
	if not done:
		print("bag full")



func _on_BodySprite_animation_finished():
	if body.animation == "attack":
		part.get_parent().hide()
		part.play("default")
		body_state = BodyStates.IDLE
		if $FindHit.is_colliding():
			var hit : Node2D = $FindHit.get_collider() as Node2D
			if hit.is_in_group("enemy"):
				hit.get_hit()



func _on_Cursor_click():
	body_state = BodyStates.ATTACK



func _on_Cursor_use(cursor : Node2D):
	cursor.use_item_process(bag[current_item], self)
	emit_signal("use", current_item, bag_qnt[current_item])
	if bag_qnt[current_item] == 0:
		bag[current_item] = "empty"
		current_item = -1
		emit_signal("equip", -1)



func _on_Animation_animation_finished(anim_name):
	if anim_name == "get_hit":
		$Animation.play("default")
