extends StaticBody3D

class_name Runner  

var speed: float = 7.5 #Esta velocidad para que el jugador sienta "prisa"
var player: Node
var light_post: LightPost 

func _ready():
	Global.register_enemy(self)
	light_post = get_node("/root/Node3D/La lucecita")
	player = get_node("/root/Node3D/Player")

func is_within_range(position: Vector3) -> bool:
	return position.distance_to(player.position) < 100.0 #Distancia provisoria. NO final

func chase_player(position: Vector3) -> Vector3:
	light_post.check_player_in_range(player.position)

	if light_post.is_on:
		position = respawn_position()  
		await delay_respawn(0.7) #Delay hasta el respawn
	else:
		var direction = (player.position - position).normalized()
		position += direction * speed  

	return position

func respawn_position() -> Vector3:
	var positions = light_post.get_positions()
	if positions.size() > 0:
		var new_position = positions[randi() % positions.size()] + Vector3(randf_range(100, 130), 0, 0)  # Respawn a 130 unidades más lejos
		return new_position  
	return position  
	
func delay_respawn(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)  
	timer.start()
	await timer.timeout  
	timer.queue_free()  

func spawn_enemy():
	print("enemigo 2 spawneado")
