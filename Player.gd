extends KinematicBody2D
export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size
var moveRight
var moveLeft
var moveUp

var id = 1 # Just to have a default for running this script solo

var isBounce = false
var bounceCounter = 0

# Called when the node enters the scene tree for the first time.
# Here we can set unique stats for different characters
# Hardcoded for now, max 8 players though so maybe this logic is fine?
func _ready():
	print("Player " + str(id) + " is ready!")
	
	if(id == 1):
		moveRight = "moveRight_arrow"
		moveLeft = "moveLeft_arrow"
		moveUp = "moveUp_arrow"
		$AnimatedSprite.animation = "rabbit"
		speed = 300
	elif (id == 2):
		moveRight = "moveRight_D"
		moveLeft = "moveLeft_A"
		moveUp = "moveUp_W"
		$AnimatedSprite.animation = "giraffe"
		speed = 300
	else:
		moveRight = "moveRight_M"
		moveLeft = "moveLeft_N"
		moveUp = "moveUp_J"
		$AnimatedSprite.animation = "parrot"
		speed = 300
	
	screen_size = get_viewport_rect().size

func _on_Player_body_entered(body):
	print("Collision!")
	print(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$ShootArea.disabled = true
	
	var velocity = Vector2.ZERO # The player's movement vector.
	var forward_face_direction = Vector2(cos(rotation), sin(rotation))
	velocity.x += 1 * forward_face_direction.x
	velocity.y += 1 * forward_face_direction.y
	
	
	if !isBounce:
		if Input.is_action_pressed(moveRight):
			rotation += 0.05
			
		if Input.is_action_pressed(moveLeft):
			rotation -= 0.05
		
		if Input.is_action_pressed(moveUp):
			$ShootArea.disabled = false
		
	else:
		if bounceCounter > 10:
			isBounce = false
			bounceCounter = 0
		else:
			bounceCounter += 1

	
	# Animation 
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	var collide = move_and_collide(velocity * delta)
	if collide:
		velocity.x = velocity.x * (-1)
		velocity.y = velocity.y * (-1)
		rotation = (rotation) + (PI)
		isBounce = true
