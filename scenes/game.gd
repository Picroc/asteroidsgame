extends Control

@onready var ship: Area2D = %Ship
@onready var asteroids: Node2D = %Asteroids
@onready var info_area: Node2D = %InfoArea

var game_score := 0

func _ready() -> void:
	ship.was_destroyed.connect(_reset_game)
	ship.scored_point.connect(_update_score)
	
func _reset_game():
	get_tree().create_timer(2).timeout.connect(
		func():
			ship.global_position = get_viewport_rect().size / 2.0
			ship.respawn()
			asteroids.clear_asteroids()
	)

func _update_score():
	game_score += 10
	info_area.score = game_score
