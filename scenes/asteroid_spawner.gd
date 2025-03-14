class_name AsteroidSpawner
extends Node2D

@export var screen_spawn_offset := -100.0
@export var random_spawn_angle := 90.0
	
func spawn_asteroids(number: int, type: int) -> void:
	for i in range(number):
		var screen_size := get_viewport_rect().size
		var screen_center := screen_size / 2.0
		
		var spawn_edges: Array[Vector2] = [
			Vector2(-screen_spawn_offset, 0.0),
			Vector2(0.0, -screen_spawn_offset),
			Vector2(screen_size.x + screen_spawn_offset, 0.0),
			Vector2(0.0, screen_size.y + screen_spawn_offset)
		]
		
		var inversed_mask: Array = spawn_edges.map(func(item: Vector2) -> Vector2:
			return Vector2(
				0.0 if item.x != 0.0 else 1.0,
				0.0 if item.y != 0.0 else 1.0
			)
		) as Array[Vector2]
		
		var rand_index := randi_range(0,3)
		
		var random_pos_vector: Vector2 = spawn_edges[rand_index] + screen_size * inversed_mask[rand_index] * Vector2(randf(),randf())
		
		var asteroid := Asteroid.new(randi_range(1,3))
		
		asteroid.global_position = random_pos_vector
		asteroid.look_at(screen_center)
		
		var random_angle_rad := (PI / 180.0) * random_spawn_angle
		asteroid.rotate(PI / 2.0)
		asteroid.rotate(randf_range(-(random_angle_rad / 2.0), random_angle_rad / 2.0))
		
		add_child(asteroid)
		
		var test_rect := ColorRect.new()
		test_rect.size = Vector2(2, 2)
		test_rect.global_position = random_pos_vector
		
		add_child(test_rect)
