@tool
extends Node2D

@export var coords_ship := [
	[0.0, 0.0], [10.0, 20.0],
	[6.0, 18.0], [-6.0, 18.0],
	[-10.0, 20.0], [0.0, 0.0]
]:
	set(new_array):
		coords_ship = new_array
		ship = float_array_to_Vector2Array(coords_ship)
		queue_redraw()
@export var line_thickness := 0.5:
	set(new_thickness):
		line_thickness = new_thickness
		queue_redraw()

var ship: PackedVector2Array

func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	var y_offset: float = coords.map(func(coord): return coord[1]).max() / 2.0
	for coord in coords:
		array.append(Vector2(coord[0], coord[1] - y_offset))
	return array

func _ready() -> void:
	ship = float_array_to_Vector2Array(coords_ship)
	
func _draw() -> void:
	var color = Color.WHITE
	
	draw_polyline(ship, color, line_thickness)
	
	#for point: Vector2 in ship.slice(0, coords_ship.size() - 1):
		#draw_circle(point, line_thickness + 0.5, color)
