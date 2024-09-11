extends Node2D

@onready var asteroid_spawner: AsteroidSpawner = %AsteroidSpawner
@onready var timer: Timer = %Timer

func _ready() -> void:
	asteroid_spawner.spawn_asteroids(5, 1.5)
	asteroid_spawner.spawn_asteroids(5, 1.0)
	
	timer.timeout.connect(func():
		asteroid_spawner.spawn_asteroids(1, 1.0)
	)
