extends Node3D




func _on_owl_timer_timeout():
	$Owl.play()
	$Owl/OwlTimer.start()
	
