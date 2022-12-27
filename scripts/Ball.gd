extends RigidBody2D

#Signal when there is a goal
signal goal

#Scores for each team
var counter_blue = 0
var counter_brown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	
	#Decide if there was a goal for right team 
	if position.x < 0 and (position.y > 400 and position.y < 750):
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_blue += 1
		get_tree().get_root().get_node("Main/score_leftTeam").text = String(counter_blue)
		emit_signal("goal")
	
	#Decide if there was a goal for left team 
	if position.x > 1920 and (position.y > 400 and position.y < 750):
		$GoalYay.play()
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		counter_brown = counter_brown + 1
		get_tree().get_root().get_node("Main/score_rightTeam").text = String(counter_brown)
		emit_signal("goal")

