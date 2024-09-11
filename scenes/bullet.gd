extends Area2D

@export var speed := 400.0
@export var shooting_range := 500.0

var traveled_distance := 0

func _ready() -> void:
	area_entered.connect(func(area): queue_free())

func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed * delta
	position += velocity
	
	traveled_distance += velocity.length()
	
	if traveled_distance >= shooting_range:
		queue_free()
