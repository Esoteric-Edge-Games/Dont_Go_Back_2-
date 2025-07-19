extends SpotLight3D

var is_on: bool = true  # Inicialmente encendido
var timer: float = 5.0  # Temporizador inicial
var cooldown: float = 5.0  # Cooldown tras apagarse
var is_in_cooldown: bool = false  # Estado del cooldown

func _ready():
	print("El poste de luz está encendido.")  # Mensaje inicial
	self.visible = true

func _process(delta: float) -> void:
	if is_in_cooldown:
		cooldown -= delta
		if cooldown <= 0:
			is_in_cooldown = false
			cooldown = 5  # Reinicia el temporizador
			self.visible = true
		else:
			self.visible = false  # Apaga la luz visualmente

	else:
		if timer > 0:
			self.visible = true  
		else:
			self.visible = false  
			is_in_cooldown = true  

func check_player_in_range(player_position: Vector3) -> bool:
	if player_position.distance_to(global_position) < 4.0:  # Distancia de 5 unidades
		if timer > 0:
			timer -= get_process_delta_time()  
			return true  # Retorna verdadero si está en rango
	else:
		# Si el jugador salió del rango, recarga el temporizador
		if timer < 5:  # Solo recarga si el timer no está completo
			timer += get_process_delta_time()  # Aumenta el timer cuando el jugador sale
			if timer > 5:
				timer = 5  # Limitar a 5 segundos

	return false
