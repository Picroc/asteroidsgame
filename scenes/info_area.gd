@tool
extends Node2D

@onready var score_number_1: Marker2D = %ScoreNumber1
@onready var score_number_2: Marker2D = %ScoreNumber2
@onready var score_number_3: Marker2D = %ScoreNumber3
@onready var score_number_4: Marker2D = %ScoreNumber4

const NUMBER_SHAPES := {
	0: [
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 10.0], [10.0, 20.0],
		[0.0, 20.0], [0.0, 10.0],
		[0.0, 0.0]
	],
	1: [
		[10.0, 0.0], [10.0, 10.0],
		[10.0, 20.0]
	],
	2: [
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 10.0], [0.0, 10.0],
		[0.0, 20.0], [10.0, 20.0]
	],
	3: [
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 10.0], [0.0, 10.0],
		[10.0, 10.0], [10.0, 20.0],
		[0.0, 20.0]
	],
	4: [
		[10.0, 0.0], [10.0, 20.0],
		[10.0, 10.0], [0.0, 10.0],
		[0.0, 0.0]
	],
	5: [
		[10.0, 0.0], [0.0, 0.0],
		[0.0, 10.0], [10.0, 10.0],
		[10.0, 20.0], [0.0, 20.0]
	],
	6: [
		[10.0, 0.0], [0.0, 0.0],
		[0.0, 20.0], [10.0, 20.0],
		[10.0, 10.0], [0.0, 10.0]
	],
	7: [
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 20.0]
	],
	8: [
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 20.0], [0.0, 20.0],
		[0.0, 0.0], [0.0, 10.0],
		[10.0, 10.0]
	],
	9: [
		[10.0, 10.0], [0.0, 10.0],
		[0.0, 0.0], [10.0, 0.0],
		[10.0, 20.0]
	]
}

var renderers: Dictionary[int, PolylineRenderer] = {
	0: null,
	1: null,
	2: null,
	3: null,
}

@export var numbers_size := 2.0
@export var score := 0:
	set(new_score):
		score = new_score
		set_new_score(score)

func _get_positions() -> Array[Vector2]:
	return [score_number_1.position, score_number_2.position, score_number_3.position, score_number_4.position]

func render_number(number: int, pos: int) -> void:
	if number < 0 or number > 9:
		return
	
	var number_shape = NUMBER_SHAPES[number]
	number_shape = number_shape.map(func(el):
		return [el[0] * numbers_size, el[1] * numbers_size]
	)
	
	var stored_renderer = renderers[pos]
	var renderer = stored_renderer if stored_renderer else PolylineRenderer.new()
	
	if !stored_renderer:
		renderers[pos] = renderer
		add_child(renderer)
	
	renderer.coords = number_shape
	renderer.position = _get_positions()[pos]
	renderer.use_circles = true
	renderer.line_thickness = 2.0
	
func _ready() -> void:
	set_new_score(0)
	
	score_number_1
	
func set_new_score(value: int) -> void:
	if !score_number_1 or !score_number_2 or !score_number_3 or !score_number_4:
		return
	
	var score: int = min(max(value, 0), 9999)
	
	var score_str = "%4d" % score
	
	for i in range(4):
		render_number(int(score_str[i]), i)
