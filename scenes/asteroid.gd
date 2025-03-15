class_name Asteroid
extends Node2D

var type_1_asteroid_base_coords := [
	[-10, 0],
	[10, 0],
	[15, 3],
	[20, 10],
	[20, 30],
	[15, 37],
	[10, 40],
	[-10, 40],
	[-15, 37],
	[-20, 30],
	[-20, 10],
	[-15, 3],
	[-10, 0]
];

var asteroid_types := {
	1: {
		"shape": type_1_asteroid_base_coords,
		"segments": 1,
		"scale": 0.5
	},
	2: {
		"shape": type_1_asteroid_base_coords,
		"segments": 2,
		"scale": 1.0
	},
	3: {
		"shape": type_1_asteroid_base_coords,
		"segments": 3,
		"scale": 1.5
	}
};

var asteroid_type := 1

var speed := 0.0
var existing_segments := 1

func _init(type: int) -> void:
	asteroid_type = type
	existing_segments = asteroid_types[asteroid_type].segments

func _ready() -> void:
	var asteroid_data = asteroid_types[asteroid_type]
	
	var asteroid_shape := generate_asteroid(asteroid_data.shape, asteroid_data.scale)
	
	draw_asteroid(asteroid_shape)
	
	var collision_shape := ConcavePolygonShape2D.new()
	collision_shape.segments = generate_collision_segments(asteroid_shape)
	
	var collision_shape_node := CollisionShape2D.new()
	collision_shape_node.shape = collision_shape
	
	var area := Area2D.new()
	
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	
	area.set_collision_layer_value(3, true)
	area.set_collision_mask_value(2, true)
	
	area.add_child(collision_shape_node)
	
	area.area_entered.connect(_on_area_entered)
	
	add_child(area)
	
	speed = randf_range(50.0, 150.0)
	
func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed
	position += velocity * delta

func destruct() -> void:
	if existing_segments > 1:
		for i in range(4):
			var asteroid := Asteroid.new(asteroid_type - 1)
			asteroid.transform = transform
			asteroid.rotate(-(PI / 2) * i)
			asteroid.position += Vector2.UP.rotated(asteroid.rotation) * 50.0
			add_sibling(asteroid)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	print("AREA DETECTED")
	destruct()
	
func generate_collision_segments(shape: PackedVector2Array) -> PackedVector2Array:
	var segments: PackedVector2Array = []
	
	for index in range(shape.size() - 1):
		segments.append(shape[index])
		segments.append(shape[index + 1])
	
	
	return segments
	
func draw_asteroid(shape: PackedVector2Array):
	var renderer := PolylineRenderer.new()
	add_child(renderer)
	
	renderer.shape = shape
	renderer.line_thickness = 1.0
	renderer.use_circles = true
	
static func generate_asteroid(base: Array, scale = 1.0) -> PackedVector2Array:
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
