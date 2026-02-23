extends CharacterBody2D

var start_drag_position:Vector2 = Vector2.ZERO

const speed = 100

func _physics_process(delta: float) -> void:
	var direction:Vector2 = Vector2.UP
	velocity = direction * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			start_drag_position = event.position
		else:
			print(start_drag_position)
			print(event.position)
