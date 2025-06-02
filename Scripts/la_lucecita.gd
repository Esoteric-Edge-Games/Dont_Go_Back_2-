extends DirectionalLight3D  

class_name LightPost  

var timer: Timer
var is_on: bool = false
var position_list: Array = [] 
var cooldown_active: bool = false  

func _ready():
	timer = Timer.new()
	timer.wait_time = 5.0
	timer.timeout.connect(_toggle_light)
	add_child(timer)  
	position_list.append(global_position)

func start_timer():
	if not cooldown_active:
		timer.start()
		print("Player está debajo del poste: Conteo 5 segundos")

func stop_timer():
	timer.stop()
	if timer.time_left == 5.0:  # Solo imprime si el timer está en 5 segundos
		print("Player salió del poste: Conteo 5 segundos")  # Mensaje al detener el timer
func _toggle_light():
	is_on = !is_on
	cooldown_active = true  
	stop_timer()
	print("Tiempo de espera hasta que el poste se recargue: 5 segundos")  # Mensaje al terminar el timer  

func get_positions() -> Array:
	return position_list

func check_player_in_range(player_position: Vector3) -> void:
	if player_position.distance_to(global_position) < 10.0:  # Distancia de la luz PROVISORIA
		start_timer()  # Inicia el temporizador si el jugador está en rango
	else:
		stop_timer()  # Detiene el temporizador si el jugador sale de rango
