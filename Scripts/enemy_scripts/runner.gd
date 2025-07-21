extends StaticBody3D

var speed: float = 1.5  # Velocidad para seguir al jugador
var runnerOn: bool = true  
var despawn_distance: float = 40.0  # Distancia del despawn
var chase_distance: float = 15.0  # Distancia para empezar a perseguir
var spawn_distance: float = 20.0  # Distancia para el spawn
@onready var player = get_node("/root/Node3D/Player")
@onready var poste = get_node("/root/Node3D/La lucecita/Poste")  # Nodo del poste de luz
@onready var RunnerMove = get_node("/root/Node3D/Runner/RunnerMoving/AnimationPlayer")

func _ready():
	Global.register_enemy(self)

func _process(delta: float) -> void:
	chase_player(delta)  

func chase_player(delta: float) -> void:
	var is_under_light = poste.check_player_in_range(player.position)  
	var playerPos = player.global_transform.origin

	if runnerOn:          
		var direction_to_player = Vector3(playerPos.x, global_position.y, playerPos.z) - global_position
		global_position += direction_to_player.normalized() * (speed / 2) * delta
		look_at(playerPos)

		if player.position.distance_to(global_position) > despawn_distance:
			despawn_enemy()
			
		
		if player.position.distance_to(global_position) < spawn_distance:  
			if player.position.distance_to(global_position) < chase_distance:   
				spawn_enemy()

		if is_under_light:
			despawn_enemy() 
		else:
			global_position += direction_to_player.normalized() * speed * delta  
	else:
		pass  # No hace nada si runnerOn es false

func spawn_enemy():
	runnerOn = true
	global_position = player.position - Vector3(randf_range(-10, 10), 0, 20)
	visible = true  # Haz visible al Runner cuando se spawnea
	RunnerMove.play("Moving")  
	print("enemigo 2 spawneado")

func despawn_enemy():
	runnerOn = false
	global_position = player.position - Vector3(randf_range(-10, 10), 0, 30) 
	visible = false  # Haz invisible al Runner al despawnearse
	RunnerMove.stop()  
	print("enemigo 2 despawneado")
