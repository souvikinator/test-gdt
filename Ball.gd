extends RigidBody2D

class_name Ball

var ball_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	ball_state = {"v": linear_velocity, "p":global_position, "c": false }
	$Label.text = "{v}\n{p}".format({"v": linear_velocity, "p":global_position })


func _on_Area2D_body_entered(body):
	ball_state = {"v": linear_velocity, "p":global_position, "c": body.is_in_group("Player") }
