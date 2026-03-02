extends CharacterBody2D

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("moving")
	look_at(Vector2(-5000, 4000))
	
	velocity = transform.x.normalized() * 200 * -1
	
	move_and_slide()
