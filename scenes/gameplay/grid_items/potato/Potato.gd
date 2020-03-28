extends GridItem

var cicle : int = 0


func _process(_delta):
	pass



func _on_Area2D_body_entered(body : Node2D):
	if body.is_in_group("pot"):
		$interactible.disabled = true
		$Cicle.start()



func _on_Cicle_timeout():
	if cicle < 5:
		cicle += 1
		if cicle == 5:
			qtd = 3
			$Cicle.start($Cicle.wait_time * 2)
			$interactible.disabled = false
		$Sprite.frame = cicle
	else:
		queue_free()
