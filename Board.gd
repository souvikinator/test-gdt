extends Node2D

var board_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
"""
func _physics_process(delta):
	board_state = $Player.player_state
	print("Board.gd {x}".format({"x":board_state}))
"""

func get_state():
	return $Player.player_state
	#print("Board.gd {x}".format({"x":board_state}))

func set_state(d):
	$Player.player_state = d

func _exit_tree():
	print("EXIT from Board")

