extends Node2D

#Player movement state
export var stopped = true

#Game over state
var game_over = false

#Main timer
var timer = Timer.new()

#Playoff timer
var pre_timer = Timer.new()

#Player scene import
var player = preload("res://scenes/Player.tscn")

#Number of players
var nrOfPlayers = 8

#List of all players in a match
var playerList = []

#Starting positions for 8 players 
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

#Called when the node enters the scene tree for the first time.
func _ready():
	
	#Transition from black screen into game
	$TransitionScreen.visible = true
	
	#Initilize all players
	for i in nrOfPlayers:
		var coordinate = playerCoordinateList[i]
		create_player(i + 1,coordinate[0],coordinate[1])
	
	#Setup main timer
	timer.connect("timeout",self,"end")
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	
	#setup playoff timer
	pre_timer.connect("timeout",self,"kickoff")
	pre_timer.wait_time = 3
	pre_timer.one_shot = true
	add_child(pre_timer)
	
	#Start timers
	timer.start()
	pre_timer.start()
	timer.paused = true
	
	#Play sound
	$Countdown.play()

#Create a player
func create_player(id,x,y):
	
	#initialize a new player instance
	var player_instance = player.instance()
	player_instance.id = id

	# Add list of positions and go through it instead
	player_instance.position = Vector2(x,y)

	# Add player to the main scene and append to player-list
	add_child(player_instance)
	playerList.append(player_instance)

#main loop
func _process(_delta):
	
	#Shows the countdown for every kick off
	if pre_timer.time_left > 2:
		$"Three".visible = true
	
	elif pre_timer.time_left > 1:
		$"Three".visible = false
		$"Two".visible = true
	
	elif pre_timer.time_left > 0:
		$"Two".visible = false
		$"One".visible = true
	
	#Shows the timer in correct format
	if timer.time_left > 60:
		var minutes := floor(timer.time_left / 60)
		var seconds := fmod(floor(timer.time_left), 60)
		
		get_node("timer_board1").text = "Time left: " + String(round(minutes)) + " min " + String(round(seconds)) + " sec "
		get_node("timer_board2").text = "Time left: " + String(round(minutes)) + " min " + String(round(seconds)) + " sec "
		
	elif round(timer.time_left) <= 10 :
		get_node("timer_board1").add_color_override("font_color", Color(timer.time_left/10, 0,0))
		get_node("timer_board2").add_color_override("font_color", Color(timer.time_left/10, 0,0))
		get_node("timer_board1").text = "Time left: " + String(round(timer.time_left)) + " sec"
		get_node("timer_board2").text = "Time left: " + String(round(timer.time_left)) + " sec"
		
	else :
		get_node("timer_board1").text = "Time left: " + String(round(timer.time_left)) + " sec"
		get_node("timer_board2").text = "Time left: " + String(round(timer.time_left)) + " sec"
		
	#Plays the ending sound
	if floor(timer.time_left) == 3 :
		$End_Countdown.play()	
	
	#Switches back to menu with a transition when the game ends
	if(game_over):
		if(Input.is_action_pressed("start_game")):
			$TransitionScreen.transition()

#Function called when main timer ends
func end():
	
	#Determine which team won and display the winner
	if(int($score_blue.text) > int($score_brown.text)):
		$TeamWonNode/TeamWon.add_color_override("font_color", Color(1,0,0))
		$TeamWonNode/TeamWon.text = "Red Team Won"
		$Trophy.visible = true
	elif(int($score_blue.text) < int($score_brown.text)):
		$TeamWonNode/TeamWon.add_color_override("font_color", Color(0,0,1))
		$TeamWonNode/TeamWon.text = "Blue Team Won"
		$Trophy.visible = true
	else:
		$TeamWonNode/PawLeft.visible = false
		$TeamWonNode/PawRight.visible = false
	
	#Display the common sprites regardless of outcome
	$TeamWonNode/Flags.visible = true
	$TeamWonNode/RedButton.visible = true
	$TeamWonNode/TeamWon.visible = true
	
	#Stops the ball and player
	$Ball.linear_velocity = Vector2(0,0)
	stopped = true

	#Game is over and play some applause
	game_over = true
	$Applause.play()

#Function called when play off timer ends
func kickoff():
	
	#Starts all players and unpauses the timer
	stopped = false
	timer.paused = false
	$"One".visible = false

#Function called when there is a goal
func _on_Ball_goal():
	
	#Stops all players and the timer
	stopped = true
	timer.paused = true
	
	#Put all player back into starting position
	for character in range(len(playerList)):
		playerList[character].position = Vector2(playerCoordinateList[character][0], playerCoordinateList[character][1])
	
	#Start the game again with pre timer
	pre_timer.start()
	
	#Plays the kick off sound
	yield(get_tree().create_timer(3), "timeout")
	$Play_off.play()

#Function called when the transition ends
func _on_TransitionScreen_transitioned():
	
	#Switch back to menu
	return get_tree().change_scene("res://scenes/Menu.tscn")
