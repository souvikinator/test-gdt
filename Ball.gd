extends RigidBody2D

class_name Ball

var id = 0

var is_initial_position_used = false
var is_playing = false
var state = null
var collided = false

var consuming_data = []

func _integrate_forces(s:Physics2DDirectBodyState):
	self.rotation_degrees = 0
	if not is_playing:
		if state:
			s.transform.origin = Vector2(state.pos[0], state.pos[1])
			#s.linear_velocity = Vector2(state.vel[0], state.vel[1])
		print("Consumed")
	if s.get_contact_count() > 0:
		var collision_pos = to_local(s.get_contact_local_position(0))
		print(">>>> ", collision_pos, s.get_contact_collider_position(0))
		print({"collider_type":s.get_contact_collider(0), "collider_pos":s.get_contact_collider_position(0), "collider_vel":s.get_contact_collider_velocity_at_position(0)})
	"""
	if sleeping:
		s.linear_velocity = Vector2.ZERO
	
	if not is_initial_position_used and not is_playing and state:
		print("consuming state...")
		s.transform.origin = Vector2(state.pos[0], state.pos[1])
		s.linear_velocity = Vector2(state.vel[0], state.vel[1])
		is_initial_position_used = true
	"""
func _ready():
	pass


func _physics_process(delta):
	if is_playing:
		id+=1
		state = {"id": id, "vel": [linear_velocity.x,linear_velocity.y], "pos":[global_position.x,global_position.y], "collided": collided }
	else:
		#print(">>>>>>> ",{"pos":[global_position.x, global_position.y],"cpos":state.pos})
		consuming_data.push_back({"id": state.id, "vel": [linear_velocity.x,linear_velocity.y], "pos":[global_position.x,global_position.y], "collided": collided})
	collided = false
	$Label.text = "{v}\n{p}".format({"v": linear_velocity, "p":global_position })


func _on_Area2D_body_entered(body):
	collided = true
