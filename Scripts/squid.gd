extends CharacterBody2D

var start_mouse_distance:float = 0.0
var mouse_hold:bool = false
var moving:bool = false
var in_sand:bool = false
var in_bubbles:bool = false
var distance_thresholds = [16, 32, 48, 64]

var speed:float = 10
var original_speed:float = 0.0
var max_speed:float = 669
var speed_reduce:float = 500

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
	
	var joystick_velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if moving:
		if in_sand and not in_bubbles:
			speed_reduce = 1500
		elif in_bubbles and not in_sand:
			speed_reduce = 250
		else:
			speed_reduce = 500
		speed -= speed_reduce * delta
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
			
func death():
	$DeathParticles.emitting = true
	$AnimatedSprite2D.play("dead")


func _on_sand_detector_body_entered(body: Node2D) -> void:
	in_sand = true


func _on_sand_detector_body_exited(body: Node2D) -> void:
	in_sand = false


func _on_bubble_detector_body_entered(body: Node2D) -> void:
	in_bubbles = true


func _on_bubble_detector_body_exited(body: Node2D) -> void:
	in_bubbles = false
