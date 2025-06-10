extends StaticBody3D

class_name Runner  

var speed: float = 7.5  # Velocidad para seguir al jugador
var player: Node
var light_post: SpotLight3D  # Cambiar a LightPost para acceder a su lógica

func _ready():
	Global.register_enemy(self)
	light_post = get_node("/root/Node3D/La lucecita/SpotLight3D")  # Cambia a LightPost
	player = get_node("/root/Node3D/Player")

func _process(delta: float) -> void:
	chase_player(delta)  # Llama a chase_player en cada frame

func chase_player(delta: float) -> void:
	# Verifica si el jugador está bajo la luz
	var is_under_light = light_post.check_player_in_range(player.position, delta)  

	if player.position.distance_to(global_position) < 30.0:  # Si el jugador está a 10 unidades
		if is_under_light:
			global_position = respawn_position()  # Respawn a 20 unidades
		else:
			if not light_post.is_on: 
				pass 
				#print("El Runner ataca al jugador porque el poste está apagado.")
			else:
				var direction = (player.position - global_position).normalized()
				global_position += direction * speed * delta  # Movimiento hacia el jugador
				#print("El Runner persigue al jugador.")
	else:
		pass
		#print("El Runner está fuera del rango de persecución.")

func spawn_enemy():
	pass
	#print("enemigo 2 spawneado")
func delay_respawn(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func respawn_position() -> Vector3:
	# Calcula una nueva posición 20 unidades lejos del jugador
	var direction = (global_position - player.position).normalized() # Direccion opuesta al jugador
	return player.position + direction * 20.0 # Nueva posición a 20 unidades lejos
