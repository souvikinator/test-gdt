extends RigidBody2D

class_name Ball

var id = 0

var is_initial_position_used = false
var is_playing = false
var state = null
var collided = false

func _integrate_forces(s:Physics2DDirectBodyState):
	self.rotation_degrees = 0

func _ready():
	pass


func _physics_process(delta):
	# if playing then set state
	if is_playing:
		id+=1
		state = {"id": id, "vel": [linear_velocity.x,linear_velocity.y], "pos":[global_position.x,global_position.y], "collided": collided }

	collided = false
	$Label.text = "{v}\n{p}".format({"v": linear_velocity, "p":global_position })


func _on_Area2D_body_entered(body):
	collided = true
