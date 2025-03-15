extends Area2D

signal scored

@export var speed := 400.0
@export var shooting_range := 500.0

var _scored = false

var traveled_distance := 0

func _ready() -> void:
	area_entered.connect(func(area):
		if !_scored:
			_scored = true
			scored.emit()
			queue_free()
	)

func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed * delta
	position += velocity
	
	traveled_distance += velocity.length()
	
	if traveled_distance >= shooting_range:
		queue_free()
