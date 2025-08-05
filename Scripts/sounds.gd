extends Node3D




func _on_owl_timer_timeout():
	$Owl.play()

func _on_howl_timer_timeout():
	$Howl.play()

func _on_irons_timer_timeout():
	$Irons.play()

func _on_branch_breaking_timer_timeout():
	$"Branch Breaking".play()
