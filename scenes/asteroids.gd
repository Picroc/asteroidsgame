extends Node2D

@onready var asteroid_spawner: AsteroidSpawner = %AsteroidSpawner
@onready var timer: Timer = %Timer

func _reset() -> void:
	asteroid_spawner.spawn_asteroids(5, 1.5)
	asteroid_spawner.spawn_asteroids(5, 1.0)

func _ready() -> void:
	_reset()
	
	timer.timeout.connect(func():
		asteroid_spawner.spawn_asteroids(1, randi_range(1,3))
	)

func clear_asteroids() -> void:
	var children = asteroid_spawner.get_children()
	for child in children:
		child.queue_free()
		
	_reset()
