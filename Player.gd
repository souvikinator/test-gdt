extends RigidBody2D

class_name Pluck

var is_selected = false
var speed_factor = 30000.0
var velocity = Vector2.ZERO


func _ready():
	self.input_pickable = true

func _integrate_forces(state):
	state.linear_velocity = velocity

func _physics_process(delta):
	var target_position = get_global_mouse_position()
	var current_pos = global_position
	if is_selected:
		velocity = calc_velocity(target_position, current_pos, delta)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			is_selected = false
			velocity = Vector2.ZERO

func calc_velocity(target_pos, current_pos, delta):
	var new_pos = global_position.linear_interpolate(target_pos, 500 * delta)
	var velocity = new_pos - current_pos
	return velocity

func _on_Player_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			is_selected = true
		else:
			is_selected = false
			velocity = Vector2.ZERO
