extends SpotLight3D

class_name LightPost  

var is_on: bool = true  # Inicialmente encendido
var position_list: Array = [] 
var timer: float = 5.0  # Temporizador inicial
var cooldown: float = 5.0  # Cooldown tras apagarse
var is_in_cooldown: bool = false  # Estado del cooldown

func _ready():
	position_list.append(global_position)
	print("El poste de luz está encendido.")  # Mensaje inicial
	self.visible = true

func _process(delta: float) -> void:
	if is_in_cooldown:
		cooldown -= delta
		if cooldown <= 0:
			is_in_cooldown = false
			timer = 5.0  # Reinicia el temporizador
			self.visible = true
			print("El poste de luz se recarga y está listo para encenderse.")
		else:
			print("Tiempo hasta que la lámpara funcione de nuevo: ", cooldown)
			self.visible = false  # Apaga la luz visualmente

	else:
		if timer > 0:
			timer -= delta  # Reduce el temporizador
			self.visible = true
			if timer <= 0:
				self.visible = false  # Apaga la luz
				is_in_cooldown = true  # Inicia cooldown
				timer = 0  # Asegura que no sea negativo
				print("El poste de luz se ha apagado.")
				self.visible = false  # Apaga la luz visualmente
		else:
			print("El poste de luz está encendido.")
			self.visible = true  # Enciende la luz visualmente

func get_positions() -> Array:
	return position_list

func check_player_in_range(player_position: Vector3, delta: float) -> bool:
	if player_position.distance_to(global_position) < 5.0:  # Distancia de 5 unidades
		if is_on:
			timer -= delta  # Reduce el temporizador si está encendido
			if timer < 0:
				timer = 0  # Asegúrate de que no sea negativo
			print("Player está debajo del poste. Timer: ", timer)
			return true  # Retorna verdadero si está en rango
	else:
		# Si el jugador salió del rango, recarga el temporizador
		if timer < 5.0:  # Solo recarga si el timer no está completo
			timer += delta  # Aumenta el timer cuando el jugador sale
			if timer > 5.0:
				timer = 5.0  # Limitar a 5 segundos
		print("Player salió del rango del poste. Timer: ", timer)

	return false  
