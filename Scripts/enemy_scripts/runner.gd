extends StaticBody3D

var speed: float = 4.5  # Velocidad para seguir al jugador
var runnerOn: bool = false  
var despawn_distance: float = 20.0 #Distancia del despawn
@onready var player = get_node("/root/Node3D/Player")
@onready var poste = get_node("/root/Node3D/La lucecita/Poste")  # Nodo del poste de luz
@onready var RunnerMove = get_node("/root/Node3D/Runner/RunnerMoving/AnimationPlayer")

func _ready():
	Global.register_enemy(self)

func _process(delta: float) -> void:
	chase_player(delta)  
	check_despawn()  

func chase_player(delta: float) -> void:
	var is_under_light = poste.check_player_in_range(player.position)  
	var playerPos = player.global_transform.origin

	var direction_to_player = (Vector3(playerPos.x, global_position.y, playerPos.z) - global_position).normalized()
	look_at(global_position + direction_to_player, Vector3.UP)

	if player.position.distance_to(global_position) < 40.0:  
		if not runnerOn:
			if player.position.distance_to(global_position) < 20.0:  
				spawn_enemy() 

		if runnerOn:
			if is_under_light:
				despawn_enemy() 
			else:
				global_position += direction_to_player * speed * delta  
		else:
			var direction = (player.position - global_position).normalized()
			direction.y = 0  
			global_position += direction * (speed / 4) * delta  # El runner persigue desde lejos a una velocidad lenta

func spawn_enemy():
	runnerOn = true
	#visible = true  # Haz visible al Runner cuando se spawnea
	RunnerMove.play("Moving")  
	print("enemigo 2 spawneado")

func respawn_position():
	global_position = player.global_position + Vector3(0, 0, 30)  

func check_despawn():
	if runnerOn and player.position.distance_to(global_position) > despawn_distance:
		despawn_enemy()  

func despawn_enemy():
	runnerOn = false
	respawn_position()  
	#visible = false  # Haz invisible al Runner al despawnearse
	RunnerMove.stop()  
	print("enemigo 2 despawneado")
