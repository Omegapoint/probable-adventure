extends RigidBody2D

var id = 1 # Just to have a default for running this script solo
export var speed = 100 # How fast the player will move (pixels/sec).
export var stopped = true

#PowerUp timer
var powerUp_timer = Timer.new()
var powerUp_timerScale = Timer.new()
var dashWeight= Timer.new()
# For specific characters
var moveRight
var moveLeft
var moveUp
var characterSpeed
var characterSprite

# For dynamic stuff
var currentSprite
var dashSprite = "dash"

# Speed dash
var speedDashCooldown = false
var speedDashCooldownTimer = 200
var speedDashTime = 0

var indexMapping = ["100","", "4", "7", "10", "13", "16", "19", "22"]

var myRotation = 0
var speedy = false
var myScale = 1
var restart = false
var isDash = false
# Called when the node enters the scene tree for the first time.
# Here we can set unique stats for different characters
# Hardcoded for now, max 8 players though so maybe this logic is fine?
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1000)
	
	#setup playoff timer
	powerUp_timer.connect("timeout",self,"end_powerup")
	powerUp_timer.wait_time = 7
	powerUp_timer.one_shot = true
	add_child(powerUp_timer)
	
	powerUp_timerScale.connect("timeout",self,"end_powerupScale")
	powerUp_timerScale.wait_time = 7
	powerUp_timerScale.one_shot = true
	add_child(powerUp_timerScale)
	
	dashWeight.connect("timeout",self,"end_dashWeight")
	dashWeight.wait_time = 1
	dashWeight.one_shot = true
	add_child(dashWeight)
	
	print("Player " + str(id) + " is ready!")
	
	if(id == 1):
		moveRight = "moveRight_arrow"
		moveLeft = "moveLeft_arrow"
		moveUp = "moveUp_arrow"
		characterSprite = "starfish"
		currentSprite =  characterSprite
		characterSpeed = 200
	elif (id == 2):
		moveRight = "moveRight_D"
		moveLeft = "moveLeft_A"
		moveUp = "moveUp_W"
		characterSprite = "jellyfish"
		currentSprite = characterSprite
		characterSpeed= 200
	elif (id == 3):
		moveRight = "moveRight_M"
		moveLeft = "moveLeft_N"
		moveUp = "moveUp_J"
		characterSprite = "crab"
		currentSprite = characterSprite
		characterSpeed = 200
	elif (id == 4):
		moveRight = "moveRight_P"
		moveLeft = "moveLeft_O"
		moveUp = "moveUp_0"
		characterSprite = "shark"
		currentSprite = characterSprite
		characterSpeed = 200
	if(id == 5):
		moveRight = "moveRight_H"
		moveLeft = "moveLeft_F"
		moveUp = "moveUp_T"
		characterSprite = "bee"
		currentSprite =  characterSprite
		characterSpeed = 200
		myRotation += PI
		
	elif (id == 6):
		moveRight = "moveRight_3"
		moveLeft = "moveLeft_1"
		moveUp = "moveUp_2"
		characterSprite = "butterfly"
		currentSprite = characterSprite
		characterSpeed= 200
		myRotation += PI
		
	elif (id == 7):
		moveRight = "moveRight_6"
		moveLeft = "moveLeft_4"
		moveUp = "moveUp_5"
		characterSprite = "ladybug"
		currentSprite = characterSprite
		characterSpeed = 200
		myRotation += PI
		
	elif (id == 8):
		moveRight = "moveRight_9"
		moveLeft = "moveLeft_7"
		moveUp = "moveUp_8"
		characterSprite = "bat"
		currentSprite = characterSprite
		characterSpeed = 200
		myRotation += PI
	
func _integrate_forces(state):
	if(get_tree().get_root().get_node("Main").stopped):
		$Fire.visible = false
		speedDashCooldown = false 
		speedDashTime = 0
		$ProgressBar.value = 200
		linear_velocity.x = 0
		linear_velocity.y = 0
		var coordinate = get_tree().get_root().get_node("Main").playerCoordinateList[id-1]
		state.transform = Transform2D(0, Vector2(coordinate[0], coordinate[1]))
	elif(isDash):
		apply_central_impulse(Vector2(500*cos(myRotation), 500*sin(myRotation)))
		weight += 100
		dashWeight.start()
		isDash = false
	else:
		if(get_tree().get_root().get_node("Main").resetPositions):
			var coordinate = get_tree().get_root().get_node("Main").playerCoordinateList[id-1]
			state.transform = Transform2D(0, Vector2(coordinate[0], coordinate[1]))
		linear_velocity.x = cos(myRotation) *characterSpeed
		linear_velocity.y = sin(myRotation) *characterSpeed



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	scale.x = myScale
	scale.y = myScale
	speed = characterSpeed
	$AnimatedSprite.animation = currentSprite
	

	var velocity = Vector2.ZERO # The player's movement vector.
	var forward_face_direction = Vector2(cos(rotation), sin(rotation))
	velocity.x += 1 * forward_face_direction.x
	velocity.y += 1 * forward_face_direction.y
		
	# Player controls 	
	if Input.is_action_pressed(moveRight):
		if(speedy):
			myRotation += 0.075
		else:
			myRotation += 0.05

	if Input.is_action_pressed(moveLeft):
		if(speedy):
			myRotation -= 0.075
		else:
			myRotation -= 0.05
		
	rotation = myRotation
	
	# Handles the dash, sets the speed of a dash and how long it lasts
	if(not get_tree().get_root().get_node("Main").stopped):
		if !speedDashCooldown:
			if Input.is_action_pressed(moveUp):
				
				$FireUp.play()
				$Fire.visible = true
				$ProgressBar.value = 0
				apply_central_impulse(Vector2(150*weight*cos(myRotation), 150*weight*sin(myRotation)))
				weight += 100
				dashWeight.start()
				speedDashTime += 1
				
				if speedDashTime >= 10:
					speedDashCooldown = true 
					speedDashTime = 0
					$Fire.visible = false
			
			# Needed in order to not get stuck in dash sprite if you do a quick dash
			if(Input.is_action_just_released(moveUp)):
				speedDashCooldown = true 
				speedDashTime = 0
				$Fire.visible = false
				
	# Handles cooldown of the speed dash
	if speedDashCooldown:
		if speedDashCooldownTimer > 0:
			$ProgressBar.value += 1
			speedDashCooldownTimer -= 1
		else:
			speedDashCooldown = false
			speedDashCooldownTimer = 200
	
	# Animation 
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	if(not get_tree().get_root().get_node("Main").stopped):	
		var collide = get_colliding_bodies()
		if(not collide == []):
			if collide[0].name in get_tree().get_root().get_node("Main").powerUpListSpeed:
				start_powerup_speed(collide)
			elif collide[0].name in get_tree().get_root().get_node("Main").powerUpListScale:
				start_powerup_scale(collide)
			elif collide[0].name in get_tree().get_root().get_node("Main").powerUpListSurprise:
				start_powerup_surprise(collide)


func end_powerup():
	weight = 10
	characterSpeed = 200
	speedy = false
	
func end_dashWeight():
	weight -= 100

	
func end_powerupScale():
	myScale = 1
	weight = 10
	get_tree().get_root().get_node("Main").bigPlayers = 100
	
func start_powerup_speed(collide):
	restart = true
	$SnackSound.play()
	var pathName = "Main/" + collide[0].name
	get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
	get_tree().get_root().get_node("Main").powerUpListSpeed.erase(collide[0].name)
	characterSpeed = 500
	weight = 100
	speedy = true
	powerUp_timer.start()
	
func start_powerup_scale(collide):
	$SnackSound.play()
	var pathName = "Main/" + collide[0].name
	get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
	get_tree().get_root().get_node("Main").powerUpListScale.erase(collide[0].name)
	myScale= 2
	weight = 100
	get_tree().get_root().get_node("Main").bigPlayers = id
	powerUp_timerScale.start()
	
func start_powerup_surprise(collide):
	var pathName = "Main/" + collide[0].name
	get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
	get_tree().get_root().get_node("Main").powerUpListSurprise.erase(collide[0].name)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var probability = rng.randf_range(0.0,1.0) 
	if(id in [4,5,6,7]):
		if(probability < 0.33):
			$PowerUpLabel.visible = true
			$PowerUpLabel.add_color_override("font_color", Color(1,1,0))
			$PowerUpLabel.text = "+1"
			var curr_goal = int(get_tree().get_root().get_node("Main/score_leftTeam").text) 
			get_tree().get_root().get_node("Main/score_leftTeam").text = String(curr_goal + 1)
			get_tree().get_root().get_node("Main").counterLeft= curr_goal + 1
		elif(probability < 0.66):
			$PowerUpLabel.visible = true
			$PowerUpLabel.add_color_override("font_color", Color(1,0,0))
			$PowerUpLabel.text = "-1"
			var curr_goal = int(get_tree().get_root().get_node("Main/score_leftTeam").text) 
			get_tree().get_root().get_node("Main/score_leftTeam").text = String(curr_goal - 1)
			get_tree().get_root().get_node("Main").counterLeft= curr_goal - 1
		else:
			$SoccerKick.play()
			get_tree().get_root().get_node("Main").add_new_ball(position)
	else:
		if(probability < 0.33):
			$PowerUpLabel.visible = true
			$PowerUpLabel.add_color_override("font_color", Color(1,1,0))
			$PowerUpLabel.text = "+1"
			$SuccessSound.play()
			var curr_goal = int(get_tree().get_root().get_node("Main/score_rightTeam").text) 
			get_tree().get_root().get_node("Main/score_rightTeam").text = String(curr_goal + 1)
			get_tree().get_root().get_node("Main").counterRight= curr_goal + 1
		elif(probability < 0.66):
			$PowerUpLabel.visible = true
			$PowerUpLabel.add_color_override("font_color", Color(1,0,0))
			$PowerUpLabel.text = "-1"
			$FailSound.play()
			var curr_goal = int(get_tree().get_root().get_node("Main/score_rightTeam").text) 
			get_tree().get_root().get_node("Main/score_rightTeam").text = String(curr_goal - 1)
			get_tree().get_root().get_node("Main").counterRight= curr_goal - 1
		else:
			$SoccerKick.play()
			get_tree().get_root().get_node("Main").add_new_ball(position)
	yield(get_tree().create_timer(2), "timeout")
	$PowerUpLabel.visible = false

