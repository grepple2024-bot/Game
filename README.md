# Game
Hello Mr. Lier, this is Jayden.
I have accidentally not commentated at my code since when AI creates code for lua it overloads the script with comments, which didn't seem very convenient for me since I did not use AI.
I noticed I had to commentate core systems just now, but it is too late for that, so I will just explain every script in this README.
DataHandler: This script handles data saving and leveling up using the Roblox API service "DataStoreService", which is the built in method in the engine to save a player's progress. It creates the player's core values on join in a folder that is a child of the player object, and overwrites those values with the player's values on their last session if they had existing data.
