extends Area2D

export var speed = 200 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


var isbounce = true
var isbounce2 = true
var counter = 0
var counter2 = 0
var velocity = Vector2.ZERO 
func _process(delta):

	if isbounce:
		var forward_face_direction = Vector2(cos(rotation), sin(rotation))
		velocity.x = 1 * forward_face_direction.x
		velocity.y = 1 * forward_face_direction.y
	
	if Input.is_action_pressed("move_right") and isbounce:
		rotation += 0.05
		
	if Input.is_action_pressed("move_left") and isbounce:
		rotation -= 0.05
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	
	position += velocity * delta
	if not isbounce:
		if counter > 10:
			isbounce = true
			counter = 0
		else:
			counter += 1
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0


func _on_Player_area_entered(area):
	velocity.x = velocity.x * (-1)
	velocity.y = velocity.y * (-1)
	rotation = (rotation) + (PI)
	isbounce = false
