extends Control

#Current selection in menu
var selected = 0

#Animation delta
var animation_delta = 0

#Called when the node enters the scene tree for the first time.
func _ready():
	$TransitionScreen.visible = true
	$Background_music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#Animates the menu selector paws
	$Left_paw.position.y += sin(animation_delta)/8
	$Right_paw.position.y += sin(animation_delta)/8
	animation_delta += 0.01
	
	#Input handling
	if Input.is_action_pressed("menu_down"):
		if(selected == 0):
			selected = 1
			$Left_paw.position.y += 180
			$Right_paw.position.y += 180

	elif Input.is_action_pressed("menu_up"):
		if(selected == 1):
			selected = 0
			$Left_paw.position.y -= 180
			$Right_paw.position.y -= 180

	elif(Input.is_action_pressed("start_game")):
		if(selected == 0):
			$TransitionScreen.transition()
		else:
			get_tree().quit()

#Function called when the transition ends
func _on_TransitionScreen_transitioned():
	
	#Switch back to menu
	return get_tree().change_scene("res://scenes/main.tscn")
