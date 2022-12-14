extends Node2D

var player = preload("res://Player.tscn")
var nrOfPlayers = 4
var playerList = []

# Map boundary 
var mapX
var mapY

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapSize = get_viewport_rect().size
	mapX = int(mapSize.x)
	mapY = int(mapSize.y)
	
	for i in nrOfPlayers:
		create_player(i + 1)

func create_player(id):
	var player_instance = player.instance()
	player_instance.id = id

	# Randomize start position of new player
	randomize()
	player_instance.position = Vector2(randi()%mapX,randi()%mapY)

	# Add player to the main scene and append to player-list
	add_child(player_instance)
	playerList.append(player_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass


func _on_Main_child_entered_tree(node):
	print("Player " + node.name + " is ready!")
