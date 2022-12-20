extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter_blue = 0
var counter_brown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if position.x < 0 and (position.y > 400 and position.y < 750):
		print("GOOOOAAAAL")
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_blue = counter_blue + 1
		get_tree().get_root().get_node("Main/score_blue").text = String(counter_blue)

		
	if position.x > 1920 and (position.y > 400 and position.y < 750):
		print("GOOOOAAAAL2")
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_brown = counter_brown + 1
		get_tree().get_root().get_node("Main/score_brown").text = String(counter_brown)
#	pass

