Godot Chat Client. 

This client was created as an example to help programmers to get to grips with the basics of the High Level Networking module in the Godot Game Engine. The following is a brief tutorial. 

![alt text](https://raw.githubusercontent.com/godotengine/godot/master/icon.png)

PREFACE:

If you are familler with Godot, you should be familler with the Godot Scene Tree where you add and remove all kinds of Nodes. Networking is no different, you create nodes that represent Users and then add them to an essentially Mega-Scene Tree containing every user shared by every user. This tutorial does not cover everything (like master, slave and rpc_id functions). It does cover basics, sync and remote functions.  

SETUP:

Before taking a look at the code we will run through the Scene Tree set up here.

![alt_text](https://imgur.com/XlFdhRQ.png)

Seeing as this is a tutorial, I've tried to keep things as simple as possible. I'll run through each of these quickly.

# MAIN: 

A Simple Node for the root, that stores all of the code functionality. 

# BACKGROUND_PANEL: 

A Simple Panel for the Chat Background. 

Note: I'm using a Label to display chat text so that the only scrolling is vertical. I would be using Multi-Line Edit but as of writing it forces horizontal scrolling which is inconvienent for a chat program.

# DISPLAY: 

A Simple RichTextLabel to display discussion in the chat

# CONNECTION_BUTTONS: 

A Simple container with four items set to fill, expand with a custom constant of no horizontal seperation to look tidy. Inside this, we have four items: Connect, Listen, IP and Port. These will be explained with code.

# MESSAGE_INPUT: 

This is where users will write their message. Messages are sent on the press of an Enter Key.

HOSTING AND CONNECTING:

INBUILT SIGNALS:

MESSAGE DISPLAYS REMOTE VS SYNC
