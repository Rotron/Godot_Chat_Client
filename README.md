# A Basic Tutorial on this Godot Chat Client. 

This client was created as an example to help programmers to get to grips with the basics of the High Level Networking module in the Godot Game Engine. The following is a brief tutorial. 

![alt_text](https://i.imgur.com/bUvuAiF.png)

## PREFACE

If you are familler with Godot, you should be familler with the Godot Scene Tree where you add and remove all kinds of Nodes. Networking is no different, you create nodes that represent Users and then add them to what is essentially a Mega-Scene Tree containing every user shared by every user. This tutorial does not cover everything (like master, slave and rpc_id functions). It does cover basics, sync and remote functions.  

## SETUP

Before taking a look at the code we will run through the Scene Tree set up here.

![alt_text](https://imgur.com/XlFdhRQ.png)

Seeing as this is a tutorial, I've tried to keep things as simple as possible. All of our code is stored in the script of the root main. The rest of this chat is just a layout I designed. Don't feel pressured to follow along too much.

Note: I'm using a Label to display chat text so that the only scrolling is vertical. I would be using Multi-Line Edit but as of writing it forces horizontal scrolling which is inconvienent for a chat program.

#### NETWORKING

![alt_text](https://i.imgur.com/3P086Tr.png)

Before networking, we set up some basics. The first two onready variables here should be self explantory, we're just creating tidier paths to our user input variables. 

The const MAX_USERS limits the chat room to the server + 1 client. Godot's High Level Networking defaults to 32 Max Users (but you can go past this if you'd like). When this number is reached, the server refuses new connections automatically.

In Godot Networking, each user (or peer) has an ID. The Server is always '1' unless otherwise stated. Other users are some combination of random numbers. This ID Helps the Network understand where you want to send a message (say you wanted to PM/DM somebody on the chat client and not have others see, you would use their ID with the rpc_id function). However here we are simply using it as a Player Identifier to see who is saying what, in place of usernames.

#### HOSTING AS SERVER

![alt_text](https://i.imgur.com/SncdECk.png)

This function is connected to the _pressed() signal of the Listen Button. 

In the first line, we've created a 'Peer' node which is essentially an empty node that will represent one of the users on the Scene Tree

In the second line, we've choosen to set this Peer as the Server, then fill in related details (which port we're hosting it on, and how many additional users can join). Take note that we're grabbing the text from the Port (which is just a shorter name for the $Connection_Buttons/Port node and then converting it to an integer.

In the third line, notice the 'get_tree()'. Here we are adding the newly defined server node to the Scene Tree. Just like we would do with any old Godot Node. 

The fourth line is something that I've wrote for convience. We get the node's network ID and set it to our player_id (in this case, we are the server, so we will have an id of '1'. 

#### CONNECTING AS CLIENT

![alt_text](https://i.imgur.com/kmEHKxq.png)

Connecting as the Client is not a huge deal different from Connecting as the Server. In line two, we aren't the server, so we don't need to set the rules on how many users are allowed. Instead we point our Client at the right IP Address and Port so we don't get lost on our way on the information highway. 

#### SIGNALS

![alt_text](https://i.imgur.com/sgXtq0M.png)

The Scene Tree has a number of built-in signals when it comes to Networking. In this case, I've decided to only use two to keep things simple. 

The first signal "connected_to_the_server" is triggered on a Client when it has successfully connected to the server. It won't trigger on the server ever (because of course you've connected if you're the server!). 

![alt_text](https://i.imgur.com/XMUy3k9.png)

When the client has successfully connected, the connected_to_server signal will trigger the _connected_ok function. Which first adds a confirmation for the client that they have successfully connected to the room. 

The second thing it does is send out a RPC or a 'Remote Procedural Call'. An RPC is really just another function call, except it can call functions from scene trees on connected computers. The first part of the RPC is the name of the function you want to call on another connected user. In this case, 'announce_user', the second part are any arguments you want to send, in this case the connected player's ID. 

![alt_text](https://i.imgur.com/2HigHOF.png)

Note the remote keyword. To call a function from another User, those functions must be authorized for that call. 'Remote', 'Sync', and 'Slave' are three keywords that authorize those calls in one way or another. Without any of those, you wouldn't be able to call the function at all from a different computer (with some exception for built-in functions).

The remote keyword means 'When a User invokes this function, execute it on all _OTHER users, the user in this case already knows he has connected due to the confirmation sent before the Remote Procedure Call. 

![alt_text](https://i.imgur.com/UkbiAVZ.png)

The second connected signal is called when a User leaves the Server. The peer is removed from the shared Scene Trees, so this will trigger on all connected users. 

#### SENDING AND RECEIVING MESSAGES

Finally, what is a chat client without chatting? 

When a user has written a message they want to send and hit enter, the message_input node will emit a signal that text has been entered which will trigger the '_on_Message_Input_text_entered(new_text)' function with the new_text being the previous text. 

![alt_text](https://i.imgur.com/vof08rj.png)

The first part of this function will clear the message input text, this is for convience sake so users don't have to constantly press backspace when entering a message. 

The second part of this function sends executes an RPC call to 'display_message', while passing in the message (new_text) as well as the ID of the person who sent it. 

![alt_text](https://i.imgur.com/WVbE6bJ.png)

Note the 'Sync' keyword here. Sync means almost exactly the same thing as the Remote keyword EXCEPT that it also happens on the user who called it, as well as everyone else. 

Also note that we are using += and not + or = by themselves. If we used +, the text wouldn't actually be updated. If we used just =, then we would be changing the text to the newest sent message everytime. Essentially deleting all of the old messages, which is not desirable in a chat client. 

# CONCLUSION

This was the most brief I could manage to help you understand the absolute basics of Godot Networking. With that brevity, I lacked the ability to be more comprehensive but the High Level Networking tutorial at the Godot Official Doc's is more than worthwhile to check out, especially if you've got the basic gist of it from this. 

If you enjoyed this article or have criticisims on it, feel free to poke me on the official Godot Discord where I go by the same name as here. Thank you for your time.

