extends Node

onready var IP_Address = $Connection_Buttons/IP_Address
onready var Port = $Connection_Buttons/Port
const MAX_USERS = 1

var player_id

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
func _on_Connect_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(IP_Address.text, int(Port.text))
	get_tree().set_network_peer(peer)
	player_id = str(get_tree().get_network_unique_id())

func _on_Listen_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(Port.text), MAX_USERS)
	get_tree().set_network_peer(peer)
	player_id = str(get_tree().get_network_unique_id())
	
func _player_connected(id):
	$Display.text += '\n ' + str(id) + ' has joined'
	
func _player_disconnected(id):
	$Display.text += '\n ' + str(id) + ' has left'
	
func _connected_ok():
	$Display.text += '\n You have joined the room'
	rpc('announce_user', player_id)
	
func _on_Message_Input_text_entered(new_text):
	$Message_Input.text = ''
	rpc('display_message', self.player_id, new_text)
	
sync func display_message(player, new_text):
	$Display.text += '\n ' + player + ' : ' + new_text
	
remote func announce_user(player):
	$Display.text += '\n ' + player + ' has joined the room' 