extends Control

@onready var ship: Area2D = %Ship
@onready var asteroids: Node2D = %Asteroids

func _ready() -> void:
	ship.was_destroyed.connect(_reset_game)
	
func _reset_game():
	get_tree().create_timer(2).timeout.connect(
		func():
			ship.global_position = get_viewport_rect().size / 2.0
			ship.respawn()
			asteroids.clear_asteroids()
	)
