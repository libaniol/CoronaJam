extends KinematicBody2D

export var default_target : Vector2
export var move_speed : float

onready var sprite : AnimatedSprite = $EnemySackSprite

var velocity : Vector2 = Vector2()

var chase_target : Node2D = null

var back_target : Vector2 = Vector2()

enum EnemyState {
	IDLE,
	BACK,
	WALK,
	CHASE,
	ATTACK
}
var state = EnemyState.IDLE
var previous_state = state


func _process(_delta):
	match state:
		EnemyState.IDLE:
			previous_state = state
			state = EnemyState.WALK
			continue
		EnemyState.WALK:
			if chase_target:
				chase_target = null
			if $FindHit.enabled:
				$FindHit.enabled = false
			look_at(default_target)
			sprite.play("walk")
			velocity = (default_target - position).normalized() * move_speed
			continue
		EnemyState.BACK:
			continue
		EnemyState.CHASE:
			look_at(chase_target.position)
			sprite.play("walk")
			velocity = (chase_target.position - position).normalized() * move_speed
			
			if $FindHit.is_colliding():
				var target : Node2D = $FindHit.get_collider() as Node2D
				if target.is_in_group("player"):
					if $HitTimer.is_stopped():
						$HitTimer.start()
			continue
		EnemyState.ATTACK:
			sprite.play("attack")
			continue



func _physics_process(_delta):
	velocity = move_and_slide(velocity)



func get_hit():
	$Animation.play("get_hit")



func _on_fov_body_entered(body : Node):
	if body.is_in_group("player"):
		if state != EnemyState.CHASE:
			previous_state = state
		state = EnemyState.CHASE
		chase_target = body as Node2D
		$FindHit.enabled = true
		$ChaseTimer.start()



func _on_ChaseTimer_timeout():
	state = previous_state



func _on_HitTimer_timeout():
	state = EnemyState.ATTACK



func _on_EnemySackSprite_animation_finished():
	if sprite.animation == "attack":
		$FindHit.enabled = true
		
		if $FindHit.is_colliding():
			if $FindHit.is_colliding():
				var target : Node2D = $FindHit.get_collider() as Node2D
				if target.is_in_group("player"):
					target.get_hit()
		state = EnemyState.CHASE
		$ChaseTimer.start()



func _on_Animation_animation_finished(anim_name):
	if anim_name == "get_hit":
		$Animation.play("default")
