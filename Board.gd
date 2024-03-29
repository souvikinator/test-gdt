extends Node2D

@onready var id = 0

@onready var is_playing = false
@onready var board_state = null
@onready var consume_data = []
@onready var stream_data = []

var file = null
var stream_file_path = "res://stream_data.json"

func _ready():
	$Player.is_playing = is_playing
	$Ball.is_playing = is_playing
	if not is_playing:
		load_file_data(stream_file_path)

func _physics_process(delta):
	$Player.look_at($Ball.global_position)
	if not is_playing:
		board_state = consume_data.pop_front()
		if board_state:
			$Ball.state = board_state.ball
			$Player.state = board_state.paddle
	else:
		if board_state:
			stream_data.push_back(board_state) # for logging into file
			
		if $Player.state and $Ball.state:
			id+=1
			board_state = {
				"id": id,
				"ball": $Ball.state,
				"paddle": $Player.state
			}

func get_state():
	return { "ball": $Player.state, "paddle": $Ball.state }

func set_state(d):
	board_state = d

func _exit_tree():
	if is_playing:
		print("WRITE TO FILE")
		save_file_data(stream_file_path,stream_data)
	print("EXIT from Board")

func load_file_data(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var data = file.get_file_as_string(file_name)
	
	var json_object = JSON.new()
	var parse_err = json_object.parse(data)
	consume_data = json_object.get_data()
	
	print("File loaded!")

func save_file_data(file_name, data):
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	print("File saved")
