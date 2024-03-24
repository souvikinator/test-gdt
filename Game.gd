extends Node2D

var game_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_state():
	return $Board.get_state()
	#print("Game.gd {x}".format({"x":game_state}))

func set_state(d):
	$Board.set_state(d)

