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
var game_over = false

func _ready():
	var mapSize = get_viewport_rect().size
	mapX = int(mapSize.x)
	mapY = int(mapSize.y)
	
	for i in nrOfPlayers:
		var coordinate = playerCoordinateList[i]
		create_player(i + 1,coordinate[0],coordinate[1])
	
	$Countdown.play()
	
	timer.connect("timeout",self,"do_this")
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	
	pre_timer.connect("timeout",self,"preview")
	pre_timer.wait_time = 3
	pre_timer.one_shot = true
	add_child(pre_timer)
	
	timer.start()
	timer.paused = true
	pre_timer.start()

func create_player(id,x,y):
	var player_instance = player.instance()
	player_instance.id = id

	# Add list of positions and go through it instead
	player_instance.position = Vector2(x,y)

	# Add player to the main scene and append to player-list
	add_child(player_instance)
	playerList.append(player_instance)

func _process(delta):
	if pre_timer.time_left > 2:
		$"Three".visible = true
	
	elif pre_timer.time_left > 1:
		$"Three".visible = false
		$"Two".visible = true
	
	elif pre_timer.time_left > 0:
		$"Two".visible = false
		$"One".visible = true
		
	if timer.time_left > 60:
		var minutes := floor(timer.time_left / 60)
		var seconds := fmod(floor(timer.time_left), 60)
		
		get_node("timer_board1").text = "Time left: " + String(round(minutes)) + " min " + String(round(seconds)) + " sec "
		get_node("timer_board2").text = "Time left: " + String(round(minutes)) + " min " + String(round(seconds)) + " sec "
		
	elif round(timer.time_left) <= 10 :
		get_node("timer_board1").add_color_override("font_color", Color(randf()*2, 0,0))
		get_node("timer_board1").text = "Time left: " + String(round(timer.time_left)) + " sec"
		get_node("timer_board2").text = "Time left: " + String(round(timer.time_left)) + " sec"
		
	else :
		get_node("timer_board1").text = "Time left: " + String(round(timer.time_left)) + " sec"
		get_node("timer_board2").text = "Time left: " + String(round(timer.time_left)) + " sec"
		
	
	if floor(timer.time_left) == 3 :
		$End_Countdown.play()	
	
	if(game_over):
		if(Input.is_action_pressed("start_game")):
			get_tree().change_scene("res://Menu.tscn")

func do_this():
	if(int($score_blue.text) > int($score_brown.text)):
		$TeamWonNode/TeamWon.add_color_override("font_color", Color(0,0,1))
		$TeamWonNode/TeamWon.text = "Red Team Won"
		$Trophy.visible = true
	elif(int($score_blue.text) < int($score_brown.text)):
		$TeamWonNode/TeamWon.add_color_override("font_color", Color(1,0,0))
		$TeamWonNode/TeamWon.text = "Blue Team Won"
		$Trophy.visible = true
	else:
		$TeamWonNode/PawLeft.visible = true
		$TeamWonNode/PawRight.visible = true
	$TeamWonNode/RedButton.visible = true
	$TeamWonNode/TeamWon.visible = true
	$Ball.linear_velocity = Vector2(0,0)
	stopped = true

	game_over = true
	$Applause.play()
	#get_tree().change_scene("res://Menu.tscn")

func preview():
	stopped = false
	timer.paused = false
	$"One".visible = false

func _on_Ball_goal():
	stopped = true
	timer.paused = true
	for character in range(len(playerList)):
		playerList[character].position = Vector2(playerCoordinateList[character][0], playerCoordinateList[character][1])
	pre_timer.start()
	$Countdown.play()

