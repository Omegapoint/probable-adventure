extends CanvasLayer

#Sends signal when the animation is finished
signal transitioned 

#Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(" fade_to_normal")
 
#Function to transition to black sreen
func transition():
	$AnimationPlayer.play("fade_to_black")

#Function called when the animation is finished
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fade_to_black':
		emit_signal("transitioned") 
		$AnimationPlayer.play(" fade_to_normal")
