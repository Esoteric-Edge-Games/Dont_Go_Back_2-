extends StaticBody3D

#Variables y constancias que hacen que el enemigo "Watcher" spawnee
@onready var cameraPlayer = ($"../Player/Camera3D")
@onready var player = $"../Player"
@onready var rng = RandomNumberGenerator.new()
var enemyPaused = false
var isSpawned = false
var timePassed = 48
var remainingTimeToSpawn = 48
var chanceToSpawn = 100
var just_spawned = false
const SPAWN_OFFSET = 5.0

const ENEMY_DURATION = 3.0
var enemyTimer = ENEMY_DURATION
var timeNotLookedAt = 0.0
const NOT_LOOK_THRESHOLD = 3.0

var orbit_angle = 0.0  # Radianes
var orbit_speed = 1.0  # Velocidad de rotación (ajustá a gusto)
var orbit_radius = 5.0  # Qué tan lejos orbita del jugador

func _physics_process(delta):
	var offset = -cameraPlayer.global_transform.basis.z
	var playerPosition = player.global_transform.origin 
	timePassed += delta
	
	if enemyPaused:
		# Aumentamos el ángulo para orbitar
		orbit_angle += orbit_speed * delta


		var x = cos(orbit_angle) * orbit_radius
		var z = sin(orbit_angle) * orbit_radius
		var enemy_pos = playerPosition + Vector3(x, 1.5, z)
		# Movimiento suave hacia la nueva posición
		global_transform.origin = global_transform.origin.lerp(enemy_pos, delta * 5.0)
		# Que mire al jugador siempre
		look_at(playerPosition, Vector3.UP)


		if just_spawned:
			var target_position = playerPosition + offset * SPAWN_OFFSET
			target_position.y += 1.5
			just_spawned = false
			offset.y = 0
			offset = offset.normalized() 
			global_transform.origin = target_position
			look_at(player.global_transform.origin, Vector3.UP)
			rotation.y = lerp_angle(rotation.y, rotation.y, delta * 5.0)
			visible = true  # por si estaba oculto
			print("👁️ Enemy spawned in front of player")


		offset.y = 0
		offset = offset.normalized() * SPAWN_OFFSET
		playerPosition += offset
		global_transform.origin = playerPosition
		var camera_forward = -cameraPlayer.global_transform.basis.z.normalized()
		var to_enemy = (global_transform.origin - cameraPlayer.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_enemy)
		if dot_value > 0.95:
			enemyTimer -= delta
			timeNotLookedAt = 0.0
			print("Player looking at enemy. Time until kill: ", enemyTimer)
		else:
			timeNotLookedAt += delta
			print("Player not looking at enemy for: ", timeNotLookedAt, " seconds")
			
		if enemyTimer <= 0.0:
			print("Watcher kills the player")
		
		if timeNotLookedAt >= NOT_LOOK_THRESHOLD:
			print("Enemy disappears because player did not look")
			restore_vars()

	elif not isSpawned:
		if timePassed >= remainingTimeToSpawn:
			print("Trying to spawn Watcher in front")
			if rng.randf_range(0, 100) < chanceToSpawn:
				remainingTimeToSpawn = 5
				chanceToSpawn = 70
				isSpawned = true
				enemyPaused = true
				just_spawned = true
				enemyTimer = ENEMY_DURATION
				timeNotLookedAt = 0.0
			else:
				print("Enemy did no spawn this time")



func restore_vars():
	enemyPaused = false
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0
	isSpawned = false
	timePassed = 0.0
	global_transform.origin = Vector3(9999, 9999, 0)

func _ready():
	rng.randomize()
	Global.register_enemy(self)

func spawn_enemy():
	print("enemigo 0 spawneado")
