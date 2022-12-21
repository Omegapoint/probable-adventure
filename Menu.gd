extends Control
var counter = 0
var counter2 = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Background_music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Paw.position.y += sin(counter2)/8
	$Paw2.position.y += sin(counter2)/8
	counter2 += 0.01
	if Input.is_action_pressed("menu_down"):
		if(counter == 0):
			counter = 1
			$Paw.position.y += 180
			$Paw2.position.y += 180
			$Button.texture = load("res://.import/button_hover.png-2b31de553b79e9199dc9cedc3ed05f54.stex")
			$Button2.texture = load("res://.import/button.png-234620e182281afdeb4aab4d2ed4f8a7.stex")
		else:
			$Button2.texture = load("res://.import/button_hover.png-2b31de553b79e9199dc9cedc3ed05f54.stex")
			$Button.texture = load("res://.import/button.png-234620e182281afdeb4aab4d2ed4f8a7.stex")
	elif Input.is_action_pressed("menu_up"):
		if(counter == 1):
			counter = 0
			$Paw.position.y -= 180
			$Paw2.position.y -= 180
			$Button2.texture = load("res://.import/button_hover.png-2b31de553b79e9199dc9cedc3ed05f54.stex")
			$Button.texture = load("res://.import/button.png-234620e182281afdeb4aab4d2ed4f8a7.stex")
		else:
			$Button.texture = load("res://.import/button_hover.png-2b31de553b79e9199dc9cedc3ed05f54.stex")
			$Button2.texture = load("res://.import/button.png-234620e182281afdeb4aab4d2ed4f8a7.stex")
	elif(Input.is_action_pressed("start_game")):
		if(counter == 0):
			get_tree().change_scene("res://main.tscn")
		else:
			get_tree().quit()
	pass

