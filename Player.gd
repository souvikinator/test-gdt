extends RigidBody2D

class_name Pluck

var is_selected = false
var impulse_strength = 30000.0
var previous_direction = Vector2.ZERO

func _ready():
	self.input_pickable = true

func _physics_process(delta):
	if is_selected:
		var target_position = get_global_mouse_position()
		var direction = (target_position - global_position)
		var dist = direction.length()
		if dist > 10:
			var impulse = direction.normalized() * delta * impulse_strength
			apply_impulse(Vector2(), impulse - previous_direction)
			previous_direction = impulse
	else:
		apply_impulse(Vector2.ZERO, Vector2.ZERO)

func move(direction, delta):
	apply_impulse(Vector2(), direction.normalized() * delta * impulse_strength)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			is_selected = false
			previous_direction = Vector2.ZERO

func _on_Player_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			is_selected = true
		else:
			is_selected = false
			previous_direction = Vector2.ZERO
