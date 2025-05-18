extends StaticBody3D

func _ready():
	Global.register_enemy(self)

func spawn_enemy():
	print("enemigo 2 spawneado")
