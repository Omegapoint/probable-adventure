extends KinematicBody2D

var id = 1 # Just to have a default for running this script solo
export var speed = 100 # How fast the player will move (pixels/sec).
export var stopped = true

#PowerUp timer
var powerUp_timer = Timer.new()
var powerUp_timerScale = Timer.new()

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

# Called when the node enters the scene tree for the first time.
# Here we can set unique stats for different characters
# Hardcoded for now, max 8 players though so maybe this logic is fine?
func _ready():
	
	#setup playoff timer
	powerUp_timer.connect("timeout",self,"end_powerup")
	powerUp_timer.wait_time = 3
	powerUp_timer.one_shot = true
	add_child(powerUp_timer)
	
	powerUp_timerScale.connect("timeout",self,"end_powerupScale")
	powerUp_timerScale.wait_time = 3
	powerUp_timerScale.one_shot = true
	add_child(powerUp_timerScale)
	
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
		rotation += PI
		
	elif (id == 6):
		moveRight = "moveRight_3"
		moveLeft = "moveLeft_1"
		moveUp = "moveUp_2"
		characterSprite = "butterfly"
		currentSprite = characterSprite
		characterSpeed= 200
		rotation += PI
		
	elif (id == 7):
		moveRight = "moveRight_6"
		moveLeft = "moveLeft_4"
		moveUp = "moveUp_5"
		characterSprite = "ladybug"
		currentSprite = characterSprite
		characterSpeed = 200
		rotation += PI
		
	elif (id == 8):
		moveRight = "moveRight_9"
		moveLeft = "moveLeft_7"
		moveUp = "moveUp_8"
		characterSprite = "bat"
		currentSprite = characterSprite
		characterSpeed = 200
		rotation += PI
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = characterSpeed
	$AnimatedSprite.animation = currentSprite
	

	var velocity = Vector2.ZERO # The player's movement vector.
	var forward_face_direction = Vector2(cos(rotation), sin(rotation))
	velocity.x += 1 * forward_face_direction.x
	velocity.y += 1 * forward_face_direction.y
		
	# Player controls 	
	if Input.is_action_pressed(moveRight):
		rotation += 0.05

	if Input.is_action_pressed(moveLeft):
		rotation -= 0.05
	
	# Handles the dash, sets the speed of a dash and  how long it lasts
	if !speedDashCooldown:
		if Input.is_action_pressed(moveUp):
			
			$FireUp.play()
			$Fire.visible = true
			$ProgressBar.value = 0
			speed = 2000
			speedDashTime += 1
			
			if speedDashTime >= 10:
				speedDashCooldown = true 
				speedDashTime = 0
				$Fire.visible = false
		
		# Needed in order to not get stuck in dash sprite if you do a quick dash
		if(Input.is_action_just_released(moveUp)):
			speedDashCooldown = true 
			speedDashTime = 0
			#currentSprite = characterSprite
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
		# Handles movement and bounce 
		var collide = move_and_collide(velocity * delta)
		if collide:
			if collide.collider.name in get_tree().get_root().get_node("Main").powerUpListSpeed:
				var pathName = "Main/" + collide.collider.name
				get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
				get_tree().get_root().get_node("Main").powerUpListSpeed.erase(collide.collider.name)
				characterSpeed += 500
				powerUp_timer.start()
			elif collide.collider.name in get_tree().get_root().get_node("Main").powerUpListScale:
				var pathName = "Main/" + collide.collider.name
				get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
				get_tree().get_root().get_node("Main").powerUpListScale.erase(collide.collider.name)
				scale.x = 2
				scale.y = 2
				powerUp_timerScale.start()
			elif collide.collider.name in get_tree().get_root().get_node("Main").powerUpListSurprise:
				var pathName = "Main/" + collide.collider.name
				get_tree().get_root().get_node("Main").remove_child(get_tree().get_root().get_node(pathName))
				get_tree().get_root().get_node("Main").powerUpListSurprise.erase(collide.collider.name)
				$PowerUpLabel.visible = true
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				var probability = rng.randf_range(0.0,1.0) 
				if(id in [4,5,6,7]):
					if(probability < 0.5):
						$PowerUpLabel.add_color_override("font_color", Color(1,1,0))
						$PowerUpLabel.text = "+1"
						var curr_goal = int(get_tree().get_root().get_node("Main/score_leftTeam").text) 
						get_tree().get_root().get_node("Main/score_leftTeam").text = String(curr_goal + 1)
						get_tree().get_root().get_node("Main/Ball").counter_left= curr_goal + 1
					else:
						$PowerUpLabel.add_color_override("font_color", Color(1,0,0))
						$PowerUpLabel.text = "-1"
						var curr_goal = int(get_tree().get_root().get_node("Main/score_leftTeam").text) 
						get_tree().get_root().get_node("Main/score_leftTeam").text = String(curr_goal - 1)
						get_tree().get_root().get_node("Main/Ball").counter_left= curr_goal - 1
				else:
					if(probability < 0.5):
						$PowerUpLabel.add_color_override("font_color", Color(1,1,0))
						$PowerUpLabel.text = "+1"
						var curr_goal = int(get_tree().get_root().get_node("Main/score_rightTeam").text) 
						get_tree().get_root().get_node("Main/score_rightTeam").text = String(curr_goal + 1)
						get_tree().get_root().get_node("Main/Ball").counter_right= curr_goal + 1
					else:
						$PowerUpLabel.add_color_override("font_color", Color(1,0,0))
						$PowerUpLabel.text = "-1"
						var curr_goal = int(get_tree().get_root().get_node("Main/score_rightTeam").text) 
						get_tree().get_root().get_node("Main/score_rightTeam").text = String(curr_goal - 1)
						get_tree().get_root().get_node("Main/Ball").counter_right= curr_goal - 1
				yield(get_tree().create_timer(2), "timeout")
				$PowerUpLabel.visible = false
			else:
				velocity.x = velocity.x * (-1)
				velocity.y = velocity.y * (-1)
				rotation = (rotation) + (PI)

func end_powerup():
	characterSpeed -= 500
	
func end_powerupScale():
	scale.x = 1
	scale.y = 1
