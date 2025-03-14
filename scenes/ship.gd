extends Area2D

signal was_destroyed

@export var max_velocity := 500.0
@export var acceleration_factor := 100.0
@export var angular_speed := 2.0
@export var dampening_factor := 5.0
@export var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@onready var ship_render: PolylineRenderer = %ShipRender
@onready var flame_renderer: Node2D = %FlameRenderer
@onready var flame_animation_timer: Timer = %FlameAnimationTimer
@onready var cannon: Marker2D = %Cannon
@onready var cannon_cooloff: Timer = %CannonCooloff

var velocity := Vector2.ZERO
var destroyed := false

func _ready() -> void:
	flame_renderer.visible = false
	flame_animation_timer.timeout.connect(func():
		flame_renderer.visible = !flame_renderer.visible
	)
	
	area_entered.connect(_on_collision)

func _process(delta: float) -> void:
	if destroyed:
		return
	
	var acceleration := 0.0
	
	var rotation_input := Input.get_axis("yaw_left", "yaw_right")
	var angular_velocity := angular_speed * delta * rotation_input
	
	if Input.is_action_pressed("shoot"):
		shoot()
	
	rotate(angular_velocity * (PI / 180.0))
	
	if Input.is_action_pressed("accelerate"):
		acceleration = acceleration_factor * delta
		set_flame_animation(true)
	else:
		set_flame_animation(false)
		
	if acceleration > 0.0:
		velocity += Vector2.UP.rotated(rotation) * acceleration
		if velocity.length() >= max_velocity:
			velocity = velocity.normalized() * max_velocity
	else:
		var dampening_vector := velocity.normalized()* dampening_factor * delta
		if dampening_vector.length() >= velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= dampening_vector
	
	position += velocity * delta
	
	var viewport_size := get_viewport_rect().size
	
	position.x = wrapf(position.x, 0.0, viewport_size.x)
	position.y = wrapf(position.y, 0.0, viewport_size.y)
	
func set_flame_animation(visible: bool) -> void:
	if visible:
		if flame_animation_timer.is_stopped():
			flame_animation_timer.start()
			flame_renderer.visible = true
	else:
		flame_animation_timer.stop()
		flame_renderer.visible = false
		
func shoot() -> void:
	if cannon_cooloff.is_stopped():
		cannon_cooloff.start()
		var bullet := bullet_scene.instantiate()
		bullet.position = cannon.global_position
		bullet.rotation = rotation
		add_sibling(bullet)
		
func _on_collision(body) -> void:
	if destroyed:
		return
	
	destroyed = true
	set_flame_animation(false)
	
	velocity = Vector2.ZERO
	ship_render.visible = false
	
	var destruction_renderer = ShipDestructionRenderer.new(ship_render.shape)
	add_child(destruction_renderer)
	
	destruction_renderer.animation_played.connect(
		func():
			was_destroyed.emit()
	)

func respawn() -> void:
	destroyed = false
	ship_render.visible = true
