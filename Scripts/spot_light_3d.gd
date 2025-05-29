extends SpotLight3D

func _ready():
	visible = true  

func toggle_flashlight():
	visible = !visible  
