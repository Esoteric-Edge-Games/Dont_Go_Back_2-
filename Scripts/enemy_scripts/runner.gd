extends StaticBody3D

var speed: float = 2.5  # Velocidad para seguir al jugador
var runnerOn: bool = false  # Inicialmente el enemigo no está spawneado
var despawn_distance: float = 20.0  # Distancia para despawnear
@onready var player = get_node("/root/Node3D/Player")
@onready var poste = get_node("/root/Node3D/La lucecita/Poste")  # Cambia a LightPost para acceder a su lógica
@onready var RunnerMove = get_node("/root/Node3D/Runner/RunnerMoving/AnimationPlayer")

func _ready():
	Global.register_enemy(self)

func _process(delta: float) -> void:
	chase_player(delta)  # Llama a chase_player en cada frame
	check_despawn()  # Verifica si debe despawnear

func chase_player(delta: float) -> void:
	var is_under_light = poste.check_player_in_range(player.position)
	var playerPos = player.global_transform.origin

	var direction_to_player = (Vector3(playerPos.x, global_position.y, playerPos.z) - global_position).normalized()
	look_at(global_position + direction_to_player, Vector3.UP)

	if player.position.distance_to(global_position) < 40.0:  # Si el jugador está a 40 unidades
		if not runnerOn:
			if player.position.distance_to(global_position) < 25.0:  # Si el jugador se acerca
				spawn_enemy()  # Llama a spawn_enemy para activar al enemigo

		if runnerOn:
			if is_under_light:
				despawn_enemy()  # Despawnear si está bajo la luz
			else:
				global_position += direction_to_player * speed * delta  # Movimiento hacia el jugador
		else:
			var direction = (player.position - global_position).normalized()
			direction.y = 0  # Ignorar el eje Y
			global_position += direction * (speed / 2) * delta  # Movimiento "de lejos"

func spawn_enemy():
	runnerOn = true
	RunnerMove.play("Moving")  # Iniciar la animación
	print("enemigo 2 spawneado")

func respawn_position():
	var random_x = randf_range(player.global_position.x - 70, player.global_position.x + 70)
	global_position = Vector3(random_x, 0.0, player.global_position.z + 70)  # Nueva posición a 70 unidades en Z

func check_despawn():
	if runnerOn and player.position.distance_to(global_position) > despawn_distance:
		despawn_enemy()  # Llamar a la función para despawnear

func despawn_enemy():
	runnerOn = false
	respawn_position()
	RunnerMove.stop()  # Detener la animación
	print("enemigo 2 despawneado")
