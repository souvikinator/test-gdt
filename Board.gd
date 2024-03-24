extends Node2D

var id = 0

var is_playing = false
var board_state = null
var consume_data = []
var stream_data = []

var file = null
var stream_file_path = "res://stream_data.json"
var consume_file_path = "res://consume_data.json"

func _ready():
	$Player.is_playing = is_playing
	$Ball.is_playing = is_playing
	file = File.new()
	if not is_playing:
		load_file_data(stream_file_path)

func _physics_process(delta):
	if not is_playing:
		board_state = consume_data.pop_front()
		if board_state:
			$Ball.state = board_state.ball
			$Player.state = board_state.paddle
	else:
		if board_state:
			stream_data.push_back(board_state)
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
	else:
		save_file_data(consume_file_path, {"ball":$Player.consuming_data, "paddle":$Player.consuming_data})
	print("EXIT from Board")

func load_file_data(file_name):
	file.open(file_name, File.READ)
	var data = file.get_as_text()
	consume_data = parse_json(data)
	file.close()
	print("File loaded!")

func save_file_data(file_name, data):
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	stream_data = []
	file.close()
	print("File saved")
