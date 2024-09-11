class_name Asteroid
extends Node2D

var asteroid_shape: PackedVector2Array

var speed := 0.0

func _init(shape: PackedVector2Array) -> void:
	asteroid_shape = shape

func _ready() -> void:
	var renderer := PolylineRenderer.new()
	add_child(renderer)
	renderer.shape = asteroid_shape
	renderer.line_thickness = 1.0
	renderer.use_circles = true
	#renderer.visible = false
	
	var collision_shape := ConcavePolygonShape2D.new()
	collision_shape.segments = generate_collision_segments(asteroid_shape)
	
	var collision_shape_node := CollisionShape2D.new()
	collision_shape_node.shape = collision_shape
	
	var area := Area2D.new()
	area.collision_mask = 0b10
	
	area.add_child(collision_shape_node)
	
	area.area_entered.connect(_on_area_entered)
	
	add_child(area)
	
	#var rotation := randf_range(-PI * 2.0, PI * 2.0)
	speed = randf_range(50.0, 150.0)
	
func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed
	position += velocity * delta

func destruct() -> void:
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
