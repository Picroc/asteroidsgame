class_name AsteroidSpawner
extends Node2D

@export var screen_spawn_offset := -100.0
@export var random_spawn_angle := 90.0

var type_1_asteroid_base_coords := [
	[-10, 0],
	[10, 0],
	[10, 10],
	[20, 10],
	[20, 30],
	[10, 30],
	[10, 40],
	[-10, 40],
	[-10, 30],
	[-20, 30],
	[-20, 10],
	[-10, 10],
	[-10, 0]
];

func generate_asteroid(base: Array, scale = 1.0) -> PackedVector2Array:
	var final_asteroid: PackedVector2Array = []
	
	final_asteroid.append(Vector2(
		base[0][0] * scale,
		base[0][1] * scale
	))
	
	for coord in base.slice(1, base.size() - 1):
		final_asteroid.append(Vector2(
			(coord[0] + randf_range(-3.0, 3.0)) * scale,
			(coord[1] + randf_range(-3.0, 3.0)) * scale
	))
	
	final_asteroid.append(Vector2(
		base[0][0] * scale,
		base[0][1] * scale
	))
	
	return final_asteroid
	
func spawn_asteroids(number: int, scale: float) -> void:
	for i in range(number):
		var coords := generate_asteroid(type_1_asteroid_base_coords, scale)
		
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
		
		var asteroid := Asteroid.new(coords)
		
		asteroid.global_position = random_pos_vector
		asteroid.look_at(screen_center)
		
		var random_angle_rad := (PI / 180.0) * random_spawn_angle
		asteroid.rotate(PI / 2.0)
		asteroid.rotate(randf_range(-(random_angle_rad / 2.0), random_angle_rad / 2.0))
		
		add_sibling(asteroid)
		
		var test_rect := ColorRect.new()
		test_rect.size = Vector2(2, 2)
		test_rect.global_position = random_pos_vector
		
		add_sibling(test_rect)
