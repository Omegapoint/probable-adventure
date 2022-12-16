extends KinematicBody2D
var id = 1 # Just to have a default for running this script solo
export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size

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
	print("Player " + str(id) + " is ready!")
	
	if(id == 1):
		moveRight = "moveRight_arrow"
		moveLeft = "moveLeft_arrow"
		moveUp = "moveUp_arrow"
		characterSprite = "butterfly"
		currentSprite =  characterSprite
		characterSpeed = 200
	elif (id == 2):
		moveRight = "moveRight_D"
		moveLeft = "moveLeft_A"
		moveUp = "moveUp_W"
		characterSprite = "crawfish"
		currentSprite = characterSprite
		characterSpeed= 200
	elif (id == 3):
		moveRight = "moveRight_M"
		moveLeft = "moveLeft_N"
		moveUp = "moveUp_J"
		characterSprite = "fish"
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
		characterSprite = "bear"
		currentSprite =  characterSprite
		characterSpeed = 200
		
	elif (id == 6):
		moveRight = "moveRight_3"
		moveLeft = "moveLeft_1"
		moveUp = "moveUp_2"
		characterSprite = "valross"
		currentSprite = characterSprite
		characterSpeed= 200
		
	elif (id == 7):
		moveRight = "moveRight_6"
		moveLeft = "moveLeft_4"
		moveUp = "moveUp_5"
		characterSprite = "goat"
		currentSprite = characterSprite
		characterSpeed = 200
		
	elif (id == 8):
		moveRight = "moveRight_9"
		moveLeft = "moveLeft_7"
		moveUp = "moveUp_8"
		characterSprite = "hedgehog"
		currentSprite = characterSprite
		characterSpeed = 200
	
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = characterSpeed
	$AnimatedSprite.animation = currentSprite
	
	var temp_velocity
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
			currentSprite = dashSprite
			speed = 2000
			speedDashTime += 1
			
			if speedDashTime >= 10:
				speedDashCooldown = true 
				speedDashTime = 0
				currentSprite = characterSprite
		
		# Needed in order to not get stuck in dash animation
		if(Input.is_action_just_released(moveUp)):
			speedDashCooldown = true 
			speedDashTime = 0
			currentSprite = characterSprite
			
	# Handles cooldown of the speed dash
	if speedDashCooldown:
		if speedDashCooldownTimer > 0:
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
	
	# Handles movement and bounce 
	var collide = move_and_collide(velocity * delta)
	if collide:
		velocity.x = velocity.x * (-1)
		velocity.y = velocity.y * (-1)
		rotation = (rotation) + (PI)





