extends Node2D
"""
is_streaming : whether game should start streaming or not
is_playable: whether game is playable or not (is not the it must be streaming)

This is controlled from the react application

SETUP:
1. create a listener for 'request_game_state' in the Game node
and send game data when
2. For streaming data from the game, create a signal "send_game_data_event"
anywhere in the game and emit that signal when game data is generated
"""


# Game specific variable (The value of these variables)
# changes from game to game
const GAME_ID = "ice-hockey" # CHANGE HERE

var consume_state = [] # received while consuming

# nodes
onready var game_node = get_node_or_null("/root/Game")

# JS interface
onready var js_console = JavaScript.get_interface("console")

var game_data_consume_callback = JavaScript.create_callback(self,"set_consume_state")

func _ready():
	
	if not game_node:
		self.throw_error("NO_GAME_NODE")
	
	var jovial = get_jovial_object()
	var active_game_id = get_active_game_id()
	if active_game_id != GAME_ID:
		self.throw_error("NO_MATCH_GAME_ID")

	jovial.set_consume_game_data(game_data_consume_callback)
	js_console.log("Callback set")


"""
NOTE: Why using _physics_process and not _process?
"""

func _physics_process(delta):
	if not is_playing():
		var d = consume_state.pop_front()
		if d:
			game_node.set_state(d)
			print(">>>> JovialAdapter.gd ",d)
		else:
			print("Waiting for data...")
	else:
		var current_game_state = game_node.get_state()
		if not current_game_state:
			return
			
		var send_data_string = JSON.print(current_game_state)
		#print(send_data_string)
		

#############################################################
###################### Jovial Methods #######################
#############################################################

func get_jovial_object():
	var jovial = JavaScript.get_interface("jovial")
	if not jovial:
		self.throw_error("NO_JOVIAL_OBJ")
	
	return jovial

func send_data_to_server(data):
	var jovial = get_jovial_object()
	# may put data validation?
	jovial.send_data(data)


func get_active_game_id():
	var jovial = self.get_jovial_object()
	if not jovial.game_id:
		self.throw_error("NO_GAME_ID")

	return jovial.game_id
	
func is_streaming():
	var jovial = self.get_jovial_object()

	if jovial.is_streaming == null:
		self.throw_error("NO_IS_STREAMING")

	return jovial.is_streaming

func is_playing():
	var jovial = self.get_jovial_object()

	if jovial.is_playing == null:
		self.throw_error("NO_IS_PLAYING")

	return jovial.is_playing

func set_consume_state(data):
	if is_playing():
		return
	
	var game_data_raw = data[0]
	if game_data_raw:
		var game_data_parse = JSON.parse(game_data_raw)
		if game_data_parse.error != OK:
			# not throwing error cus it;s data related error 
			# and can be fixed by fixing data format
			js_console.log("Error parsing game data....") 
			return
			
		consume_state.push_back(game_data_parse.result)

#############################################################
###################### SIGNALS ##############################
#############################################################

#func listen_game_data_and_send():
#	game.connect("send_game_data_event",self,"send_data_to_server")

func is_same_game_state(prev_game_state: Dictionary, current_game_state: Dictionary):
	return prev_game_state.hash() == current_game_state.hash()

#############################################################
###################### UTILS ##############################
#############################################################

func throw_error(error_code:String):
	match error_code:
		"NO_GAME_NODE": self.print_error(error_code,"game node not found")
		"NO_JOVIAL_OBJ": self.print_error(error_code,"jovial object not found")
		"NO_IS_STREAMING": self.print_error(error_code,"is_streaming not found")
		"NO_IS_PLAYING": self.print_error(error_code,"is_playing not found")
		"NO_GAME_ID": self.print_error(error_code,"game_id not found")
		"NO_MATCH_GAME_ID": self.print_error(error_code,"the active game id doesn't match with the current game")
	return

func print_error(error_code:String ,msg:String):
	js_console.error("["+error_code+"] ",msg)
	assert(false, msg)
	OS.exit_code(1)

func Vector2Array(v:Vector2):
	return [v.x,v.y]

func Array2Vector2(a:Array):
	return Vector2(a[0],a[1])
