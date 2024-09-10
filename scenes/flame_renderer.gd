@tool
extends Node2D

@export var coords_flame := [
	[-5.0, 19.0], [0.0, 25.0], [5.0, 19.0]
]:
	set(new_array):
		coords_flame = new_array
		flame = float_array_to_Vector2Array(coords_flame)
		queue_redraw()
@export var line_thickness := 0.5:
	set(new_thickness):
		line_thickness = new_thickness
		queue_redraw()

var flame: PackedVector2Array

func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	var y_offset: float = coords.map(func(coord): return coord[1]).max() / 2.0
	for coord in coords:
		array.append(Vector2(coord[0], coord[1] - y_offset))
	return array

func _ready() -> void:
	flame = float_array_to_Vector2Array(coords_flame)
	
func _draw() -> void:
	var color = Color.WHITE
	
	draw_polyline(flame, color, line_thickness)
	
	#for point: Vector2 in ship.slice(0, coords_ship.size() - 1):
		#draw_circle(point, line_thickness + 0.5, color)
