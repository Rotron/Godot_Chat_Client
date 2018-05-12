Godot Chat Client. 

This client was created as an example to help programmers to get to grips with the basics of the High Level Networking module in the Godot Game Engine. The following is a brief tutorial. 

![alt text](https://raw.githubusercontent.com/godotengine/godot/master/icon.png)

## PREFACE

If you are familler with Godot, you should be familler with the Godot Scene Tree where you add and remove all kinds of Nodes. Networking is no different, you create nodes that represent Users and then add them to what is essentially a Mega-Scene Tree containing every user shared by every user. This tutorial does not cover everything (like master, slave and rpc_id functions). It does cover basics, sync and remote functions.  

## SETUP

Before taking a look at the code we will run through the Scene Tree set up here.

![alt_text](https://imgur.com/XlFdhRQ.png)

Seeing as this is a tutorial, I've tried to keep things as simple as possible. I'll run through each of these quickly.

#### MAIN

A Simple Node for the root, that stores all of the code functionality. 

#### BACKGROUND_PANEL

A Simple Panel for the Chat Background. 

Note: I'm using a Label to display chat text so that the only scrolling is vertical. I would be using Multi-Line Edit but as of writing it forces horizontal scrolling which is inconvienent for a chat program.

#### DISPLAY

A Simple RichTextLabel to display discussion in the chat

#### CONNECTION_BUTTONS

A Simple container with four items set to fill, expand with a custom constant of no horizontal seperation to look tidy. Inside this, we have four items: Connect, Listen, IP and Port. These will be explained with code.

#### MESSAGE_INPUT

This is where users will write their message. Messages are sent on the press of an Enter Key.

#### NETWORKING

onready var IP_Address = $Connection_Buttons/IP_Address
onready var Port = $Connection_Buttons/Port
const MAX_USERS = 1
var player_id

Before networking, we set up some basics. The first two onready variables here should be self explantory, we're just creating tidier paths to our user input variables. 

The const MAX_USERS limits the chat room to the server + 1 client. Godot's High Level Networking defaults to 100 Max Users. When this number is reached, the server refuses new connections automatically.

In Godot Networking, each user (or peer) has an ID. The Server is always '1' unless otherwise stated. Other users are some combination of random numbers. This ID Helps the Network understand where you want to send a message (say you wanted to PM/DM somebody on the chat client and not have others see, you would use their ID with the rpc_id function). However here we are simply using it as a Player Identifier to see who is saying what, in place of usernames.

#### HOSTING AS SERVER

func _on_Listen_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(Port.text), MAX_USERS)
	get_tree().set_network_peer(peer)
	player_id = str(get_tree().get_network_unique_id())

This function is connected to the _pressed() signal of the Listen Button. 

In the first line, we've created a 'Peer' node which is essentially an empty node that will represent one of the users on the Scene Tree

In the second line, we've choosen to set this Peer as the Server, then fill in related details (which port we're hosting it on, and how many additional users can join). Take note that we're grabbing the text from the Port (which is just a shorter name for the $Connection_Buttons/Port node and then converting it to an integer.

In the third line, notice the 'get_tree()'. Here we are adding the newly defined server node to the Scene Tree. Just like we would do with any old Godot Node. 

The fourth line is something that I've wrote for convience. We get the node's network ID and set it to our player_id (in this case, we are the server, so we will have an id of '1'. 

#### CONNECTING AS CLIENT

# CLIENT VERSION

Connecting as the Client is not a huge deal different from Connecting as the Server. In line two, we aren't the server, so we don't need to set the rules on how many users are allowed. Instead we point our Client at the right IP Address and Port so we don't get lost on our way on the information highway. 

#### SIGNALS

![alt_text](https://i.imgur.com/sgXtq0M.png)
	
func _connected_ok():
	$Display.text += '\n You have joined the room'
	rpc('announce_user', player_id)
	
The Scene Tree has a number of built-in signals when it comes to Networking. In this case, I've decided to only use two to keep things simple. 

The first signal "connected_to_the_server" is triggered on a Client when it has successfully connected to the server. It won't trigger on the server ever (because of course you've connected if you're the server!). 

When the client has successfully connected, the connected_to_server signal will trigger the _connected_ok function. Which first adds a confirmation for the client that they have successfully connected to the room. 

The second thing it does is send out a RPC or a 'Remote Procedural Call'. An RPC is really just another function call, except it can call functions from scene trees on connected computers. The first part of the RPC is the name of the function you want to call on another connected user. In this case, 'announce_user', the second part are any arguments you want to send, in this case the connected player's ID. 

remote func announce_user(player):
	$Display.text += '\n ' + player + ' has joined the room' 

Note the remote keyword. To call a function from another User, those functions must be authorized for that call. 'Remote', 'Sync', and 'Slave' are three keywords that authorize those calls in one way or another. Without any of those, you wouldn't be able to call the function at all from a different computer (with some exception for built-in functions).

The remote keyword means 'When a User invokes this function, execute it on all __OTHER users, the user in this case already knows he has connected due to the confirmation sent before the Remote Procedure Call. 

func _player_disconnected(id):
	$Display.text += '\n ' + str(id) + ' has left'
	
The second connected signal is called when a User leaves the Server. The peer is removed from the shared Scene Trees, so this will trigger on all connected users. 

#### SENDING AND RECEIVING MESSAGES

