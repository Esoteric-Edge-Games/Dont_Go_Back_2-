extends StaticBody3D

var speed: float = 2.5  # Velocidad para seguir al jugador
var runnerOn: bool = false  
var despawn_distance: float = 40.0  # Distancia del despawn
var spawn_distance: float = 30.0 #Distancia para el spawn
@onready var player = get_node("/root/Node3D/Player")
@onready var poste = get_node("/root/Node3D/La lucecita/Poste")  # Nodo del poste de luz
@onready var RunnerMove = get_node("/root/Node3D/Runner/RunnerMoving/AnimationPlayer")
@onready var RunnerColl = get_node("/root/Node3D/Runner/CollisionShape3D")

func _ready():
	visible = false
	Global.register_enemy(self)

func _process(delta: float) -> void:
	if runnerOn:
		chase_player(delta)  
		check_collision_with_player()

func chase_player(delta: float) -> void:
	var is_under_light = poste.check_player_in_range(player.position)  
	var playerPos = player.global_transform.origin #La posicion de player se guarda para que runner lo persiga a esas mismas "coordenadas"
	  
	var direction_to_player = Vector3(playerPos.x, global_position.y, playerPos.z) - global_position
	global_position += direction_to_player.normalized() * (speed / 2) * delta #Esta es la velocidad reducida que sigue runner a player
	look_at(playerPos)

	if player.position.distance_to(global_position) > despawn_distance:
		despawn_enemy()

	if player.position.distance_to(global_position) > spawn_distance:    
		spawn_enemy()

	if is_under_light:
		despawn_enemy() 
	else:
		global_position += direction_to_player.normalized() * speed * delta  #Velocidad "normal"
	

		
func check_collision_with_player():
	var playerPos = player.global_transform.origin
	var distance = RunnerColl.global_transform.origin.distance_to(playerPos)
	if distance <= 2.5:  #Distancia aproximada de muerte. Para que no sea exactamente la posicion de player
		print("Runner mató a Player")

func spawn_enemy():
	if not runnerOn:
		runnerOn = true
		global_position = player.position - Vector3(randf_range(-10, 10), 0, randf_range(5, 20))
		visible = true # Haz visible al Runner cuando se spawnea
		RunnerMove.play("Moving")  
		print("Runner spawneo")

func despawn_enemy():
	runnerOn = false 
	visible = false  # Haz invisible al Runner al despawnearse
	RunnerMove.stop()  
	print("Runner despawneo")
