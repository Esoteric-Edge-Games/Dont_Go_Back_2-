""" 
El Runner es la placa continental del gameplay ya que sostiene el hecho de que no puedas retroceder 
el mismo tendrá ataques como el resto pero su verdadera finalidad es que no regreses, ya que con una 
serie de X cantidad de pasos el mismo te atacará obligándome a correr en la dirección contraria o 
afrontar la muerte.
si se corre hasta un lugar iluminado el mismo será un punto seguro hasta que la luz se apague

TODO
Tipo : movimiento, iluminación 
anti tipo : anti movimiento, observación.
Arquetipo: Hostil

Movimiento : Te obliga a moverte de tu lugar. No ataca si estás bajo un poste de luz a no ser que este se apague.
Iluminación: Te obliga a moverte a un lugar iluminado por al menos 3 segundos.
 
Anti movimiento : Te obliga a quedarte quieto
anti observación : te obliga dejar de mirar
"""

extends StaticBody3D

class_name Runner  

var speed: float = 7.5 #Esta velocidad para que el jugador sienta "prisa"
var player: Node
var light_post: LightPost 

func is_within_range(position: Vector3) -> bool:
	return position.distance_to(player.position) < 100.0 #Distancia provisoria. NO final

func chase_player(position: Vector3) -> Vector3:
	if light_post.is_on:
		position = respawn_position()  
		await delay_respawn(0.7) #este delay estaba en el else. Menos mal que lo vi
	else:
		var direction = (player.position - position).normalized()
		position += direction * speed  

	return position

func respawn_position() -> Vector3:
	var positions = light_post.get_positions()
	if positions.size() > 0:
		return positions[randi() % positions.size()]  
	return position  
	
func delay_respawn(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)  
	timer.start()
	await timer.timeout  
	timer.queue_free()  

func _ready():
	Global.register_enemy(self)
	light_post = $LightPost
	player = $Player

func spawn_enemy():
	var enemy = Runner.new()
	print("enemigo 2 spawneado")
	add_child(enemy)
