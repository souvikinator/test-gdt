extends KinematicBody2D

class_name Paddle

var is_selected = false
var is_initial_position_used = false
var is_playing = false
var state = null
var id = 0

var consuming_data = []

func _ready():
	self.input_pickable = true
	$Label.text = "{v}\n{p}".format({"v": Vector2.ZERO, "p":global_position })

func _physics_process(delta):
	#print(JSON.print(state))
	if not is_playing:
		# consume
		if state:
			var mouse = state.mouse
			var target_pos = Vector2(mouse.pos[0], mouse.pos[1])
			var current_pos = Vector2(state.paddle.pos[0], state.paddle.pos[1])
			if not is_initial_position_used:
				self.global_position = current_pos
				is_initial_position_used = true
			var velocity = Vector2.ZERO
			if mouse.active:
				velocity = Vector2(state.paddle.vel[0],state.paddle.vel[1])
				#velocity = calc_velocity(target_pos, current_pos, delta)
				move_and_slide(velocity)
			else:
				move_and_slide(velocity)
			
			consuming_data.push_back({"id":state.id, "vel": [velocity.x,velocity.y], "pos":[current_pos.x,current_pos.y], "delta":delta})
			$Label.text = "{v}\n{p}".format({"v": velocity, "p": self.global_position })
	else:
		# send
		handle_drag_input(delta)

func handle_drag_input(delta):
	id+=1
	var current_pos = global_position
	var target_pos = get_global_mouse_position()
	if is_selected:
		var velocity = calc_velocity(target_pos, current_pos, delta)
		move_and_slide(velocity)
		state = {"id": id, "paddle":{"vel":[velocity.x,velocity.y], "pos":[current_pos.x,current_pos.y]}, 
		"mouse":{"pos":[target_pos.x,target_pos.y],"active":true}
		}
		$Label.text = "{v}\n{p}".format({"v": velocity, "p":current_pos }
		)
	else:
		state = {"id":id ,"paddle":{"vel":[0,0], "pos":[current_pos.x,current_pos.y]}, 
		"mouse":{"pos":[target_pos.x,target_pos.y],"active":false}
		}
		$Label.text = "{v}\n{p}".format({"v": Vector2.ZERO, "p":current_pos })

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			is_selected = false

func calc_velocity(target_pos, current_pos, delta):
	var new_pos = global_position.linear_interpolate(target_pos, 500 * delta)
	var velocity = new_pos - current_pos
	return velocity

func _on_Player_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed('click'):
		is_selected = true
