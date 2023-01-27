extends RigidBody2D

#Signal when there is a goal
signal goal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if position.x < -200 or position.x > 2200:
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2(0,0)
	elif position.y < -50 or position.y > 1100:
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2(0,0)
	#Decide if there was a goal for right team 
	elif position.x < 0 and (position.y > 390 and position.y < 700):
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2(0,0)
		get_tree().get_root().get_node("Main").counterLeft += 1
		get_tree().get_root().get_node("Main/score_leftTeam").text = String(get_tree().get_root().get_node("Main").counterLeft)
		get_tree().get_root().get_node("Main")._on_Ball_goal()
	
	#Decide if there was a goal for left team 
	elif position.x > 1920 and (position.y > 390 and position.y < 700):
		state.transform = Transform2D(0, Vector2(1920/2,1080/2))
		state.linear_velocity = Vector2(0,0)
		get_tree().get_root().get_node("Main").counterRight +=1
		get_tree().get_root().get_node("Main/score_rightTeam").text = String(get_tree().get_root().get_node("Main").counterRight)
		get_tree().get_root().get_node("Main")._on_Ball_goal()

