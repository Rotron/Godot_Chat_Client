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
  
In this example, I've attached the '_pressed()' signal from the listen button (previously shown in the scene tree)


INBUILT SIGNALS:

MESSAGE DISPLAYS REMOTE VS SYNC
