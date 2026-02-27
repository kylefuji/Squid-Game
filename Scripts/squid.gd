extends CharacterBody2D

var start_mouse_distance:float = 0.0
var mouse_hold:bool = false
var moving:bool = false
var distance_thresholds = [8, 16, 24, 32]

var speed:float = 10
var original_speed:float = 0.0
var max_speed:float = 669

func _ready() -> void:
	original_speed = speed


func _physics_process(delta: float) -> void:
	if mouse_hold:
		look_at(get_global_mouse_position())
		
		var current_mouse_distance:float = get_global_mouse_position().distance_to(position) - start_mouse_distance
		if current_mouse_distance < distance_thresholds[0]:
			$AnimatedSprite2D.play("sling0")
		elif current_mouse_distance >= distance_thresholds[0] and current_mouse_distance < distance_thresholds[1]:
			$AnimatedSprite2D.play("sling1")
		elif current_mouse_distance >= distance_thresholds[1] and current_mouse_distance < distance_thresholds[2]:
			$AnimatedSprite2D.play("sling2")
		elif current_mouse_distance >= distance_thresholds[2] and current_mouse_distance < distance_thresholds[3]:
			$AnimatedSprite2D.play("sling3")
		else:
			$AnimatedSprite2D.play("sling4")
	
	if moving:
		speed -= 500 * delta
		if speed <= 0:
			moving = false
			$AnimatedSprite2D.play("idle")
			velocity = Vector2.ZERO
			move_and_slide()
			return
		velocity = transform.x.normalized() * speed * -1
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			mouse_hold = true
			start_mouse_distance = get_global_mouse_position().distance_to(position)
		else:
			$AnimatedSprite2D.play("moving")
			mouse_hold = false
			var current_mouse_distance:float = get_global_mouse_position().distance_to(position) - start_mouse_distance
			speed = min(current_mouse_distance * original_speed, max_speed)
			moving = true
