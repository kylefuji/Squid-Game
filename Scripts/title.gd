extends Node2D

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.html("#3f3f74"))
	$Timer.connect("timeout", _on_timer_timeout)
	$Timer.start()

func _on_timer_timeout() -> void:
	get_tree().paused = true
