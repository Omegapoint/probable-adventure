extends RigidBody2D
signal goal

var counter_blue = 0
var counter_brown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if position.x < 0 and (position.y > 400 and position.y < 750):
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_blue += 1
		get_tree().get_root().get_node("Main/score_blue").text = String(counter_blue)
		emit_signal("goal")
		
	if position.x > 1920 and (position.y > 400 and position.y < 750):
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_brown = counter_brown + 1
		get_tree().get_root().get_node("Main/score_brown").text = String(counter_brown)
		emit_signal("goal")

