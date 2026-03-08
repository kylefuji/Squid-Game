extends CharacterBody2D

var start_mouse_distance:float = 0.0
var mouse_hold:bool = false
var moving:bool = false
var in_sand:bool = false
var in_bubbles:bool = false
var in_flag:bool = false
var distance_thresholds = [32, 64, 96, 128]
var using_mouse:bool = true

var speed:float = 5
var original_speed:float = 0.0
var max_speed:float = 669
var speed_reduce:float = 500
var flag_delta:float = 0

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
	if using_mouse:
		look_at(get_global_mouse_position())
		
	var joystick_velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if in_flag:
		flag_delta += delta
		var target_pos = Vector2(
			cos(flag_delta * 10) * 100, sin(flag_delta * 10) * 100
		)
		
		look_at(global_position + target_pos)
		moving = false
		velocity = get_gravity() * delta
		move_and_slide()
		
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
			mouse_hold = false
			var current_mouse_distance:float = get_global_mouse_position().distance_to(position) - start_mouse_distance
			if current_mouse_distance < distance_thresholds[0]:
				return
			$AnimatedSprite2D.play("moving")
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


func _on_flag_body_entered(body: Node2D) -> void:
	if body == self:
		speed = 0
		in_flag = true
