class_name ShipDestructionRenderer
extends Node2D

signal animation_played

var lines: PackedVector4Array = []
var shape: PackedVector2Array = []

var line_hide_thesholds: PackedFloat32Array = []

var animation_duration := 5.0
var target_offset := 50

func _init(ship_coords: PackedVector2Array) -> void:
	var last_point := ship_coords[0]
	
	for coord in ship_coords.slice(1):
		lines.append(Vector4(last_point.x, last_point.y, coord.x, coord.y))
		line_hide_thesholds.append(randf_range(target_offset * 0.7, target_offset))
		last_point = coord
		

func _ready() -> void:
	var animation_tween = create_tween()
	
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.set_trans(Tween.TRANS_QUAD)
	
	animation_tween.tween_method(_set_shape_with_animation_offset, 0.0, target_offset, animation_duration)
	animation_tween.finished.connect(
		func():
			animation_played.emit()
			queue_free()
	)
	
	animation_tween.play()

func _draw() -> void:
	var color := Color.WHITE
	
	if shape.size() > 0:
		draw_multiline(shape, color, 2.0)

func _set_shape_with_animation_offset(animation_offset: float) -> void:
	var new_shape: PackedVector2Array = []
	
	for idx in range(lines.size()):
		if animation_offset > line_hide_thesholds[idx]:
			continue
		
		var line = lines[idx]
		
		var offset_vector := Vector2(line.z, line.w) - Vector2(line.x, line.y)
		offset_vector = offset_vector.rotated(-90).normalized() * animation_offset
		
		new_shape.append(Vector2(line.x, line.y) + offset_vector)
		new_shape.append(Vector2(line.z, line.w) + offset_vector)
		
	shape = new_shape
	queue_redraw()
