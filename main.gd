extends Node2D

var timer = Timer.new()
var pre_timer = Timer.new()
var player = preload("res://Player.tscn")
export var stopped = true
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
	
	$Countdown.play()
	
	timer.connect("timeout",self,"do_this")
	timer.wait_time = 20
	timer.one_shot = true
	add_child(timer)
	
	pre_timer.connect("timeout",self,"preview")
	pre_timer.wait_time = 3
	pre_timer.one_shot = true
	add_child(pre_timer)
	
	timer.start()
	pre_timer.start()

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
	if pre_timer.time_left > 2:
		$"Three".visible = true
	
	elif pre_timer.time_left > 1:
		$"Three".visible = false
		$"Two".visible = true
	
	elif pre_timer.time_left > 0:
		$"Two".visible = false
		$"One".visible = true
		
	#elif pre_timer.time_left > 0:
	#	$"One".visible = false
	#	$"Zero".visible = true
	
	pass

func do_this():
	#print('wait 3 seconds and do this....')
	get_tree().change_scene("res://Menu.tscn")
	print("preview")
	stopped = false
	#get_tree().get_root().get_node("Player").stopped = false

func preview():
	print("preview")
	stopped = false
	$"One".visible = false
	#get_tree().get_root().get_node("Player").stopped = false

