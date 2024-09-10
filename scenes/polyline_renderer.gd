@tool
extends Node2D

@export var use_circles := false
@export var coords := [
	[0.0, 0.0], [10.0, 20.0],
	[6.0, 18.0], [-6.0, 18.0],
	[-10.0, 20.0], [0.0, 0.0]
]:
	set(new_array):
		coords = new_array
		shape = float_array_to_Vector2Array(coords)
		queue_redraw()
@export var line_thickness := 0.5:
	set(new_thickness):
		line_thickness = new_thickness
		queue_redraw()

var shape: PackedVector2Array

func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	var y_offset: float = coords.map(func(coord): return coord[1]).max() / 2.0
	for coord in coords:
		array.append(Vector2(coord[0], coord[1] - y_offset))
	return array

func _ready() -> void:
	shape = float_array_to_Vector2Array(coords)
	
func _draw() -> void:
	var color := Color.WHITE
	var gray_color := Color.LIGHT_GRAY
	
	draw_polyline(shape, gray_color if use_circles else color, line_thickness)
	
	if use_circles:
		for point: Vector2 in shape.slice(0, shape.size() - 1):
			draw_circle(point, line_thickness + 0.5, color)
