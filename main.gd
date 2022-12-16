extends Node2D

var player = preload("res://Player.tscn")
var nrOfPlayers = 8
var playerList = []
var playerCoordinateList = [
	# Team blue
	[150,540],
	[450,890],
	[450,190],
	[750,540],
	
	# Team brown
	[1770,540],
	[1470,890],
	[1470,190],
	[1170,540]
	]


# Map boundary 
var mapX
var mapY

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapSize = get_viewport_rect().size
	mapX = int(mapSize.x)
	mapY = int(mapSize.y)
	
	for i in nrOfPlayers:
		var coordinate = playerCoordinateList[i]
		create_player(i + 1,coordinate[0],coordinate[1])

func create_player(id,x,y):
	var player_instance = player.instance()
	player_instance.id = id

	# Add list of positions and go through it instead
	player_instance.position = Vector2(x,y)

	# Add player to the main scene and append to player-list
	add_child(player_instance)
	playerList.append(player_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
