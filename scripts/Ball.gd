extends RigidBody2D

#Signal when there is a goal
signal goal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	
	#Decide if there was a goal for right team 
	if position.x < 0 and (position.y > 390 and position.y < 700):
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		get_tree().get_root().get_node("Main").counterLeft += 1
		get_tree().get_root().get_node("Main/score_leftTeam").text = String(get_tree().get_root().get_node("Main").counterLeft)
		get_tree().get_root().get_node("Main").goal = true
	
	#Decide if there was a goal for left team 
	if position.x > 1920 and (position.y > 390 and position.y < 700):
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2()
		get_tree().get_root().get_node("Main").counterRight +=1
		get_tree().get_root().get_node("Main/score_rightTeam").text = String(get_tree().get_root().get_node("Main").counterRight)
		get_tree().get_root().get_node("Main").goal = true

