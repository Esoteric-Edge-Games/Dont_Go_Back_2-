extends StaticBody3D

#Variables y constancias que hacen que el enemigo "Watcher" spawnee
@onready var cameraPlayer = $"../Player/Node3D/Camera3D"
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

var last_delta = 0.0

func _physics_process(delta):
	last_delta = delta
	spawn_enemy()
	pass


func restore_vars():
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0
	isSpawned = false
	timePassed = 0.0
	global_transform.origin = Vector3(9999, 9999, 0)
	Global.watcherIsSpawned = false
	cameraPlayer.unfocus_on_watcher()
	


func _ready():
	rng.randomize()
	Global.register_enemy(self)

func spawn_enemy():
	if just_spawned:
# Buscar la cámara y hacer que enfoque
		cameraPlayer.look_at_enemy_watcher = true
		cameraPlayer.enemy_ref = self
		cameraPlayer.focus_on_watcher(self)
		just_spawned = false

	timePassed += last_delta
	var offset = -cameraPlayer.global_transform.basis.z
	var playerPosition = player.global_transform.origin 


	if (isSpawned):

		orbit_angle += orbit_speed * last_delta
		var x = cos(orbit_angle) * orbit_radius
		var z = sin(orbit_angle) * orbit_radius
		var enemy_pos = player.global_transform.origin + Vector3(x, 2.5, z)
		# Movimiento suave hacia la nueva posición
		global_transform.origin = global_transform.origin.lerp(enemy_pos, last_delta * 5.0)
		# Que mire al jugador siempre
		look_at(playerPosition, Vector3.UP)

		var camera_forward = -cameraPlayer.global_transform.basis.z.normalized()
		var to_enemy = (global_transform.origin - cameraPlayer.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_enemy)
		if dot_value > 0.95:
			player_is_looking_at_watcher(last_delta)
		else:
			player_is_not_looking_at_watcher(last_delta)
		if enemyTimer <= 0.0:
			print("Watcher kills the player")
	
		if timeNotLookedAt >= NOT_LOOK_THRESHOLD:
			despawn_enemy()
		
	elif not isSpawned:
		if timePassed >= remainingTimeToSpawn:
			print("Trying to spawn Watcher in front")
			if rng.randf_range(0, 100) < chanceToSpawn:
				remainingTimeToSpawn = 12
				chanceToSpawn = 70
				isSpawned = true
				just_spawned = true
				enemyTimer = ENEMY_DURATION
				timeNotLookedAt = 0.0
			else:
				print("Enemy did no spawn this time")


func despawn_enemy():
	print("Enemy disappears because player did not look")
	restore_vars()
	
	print("Watcher Despawned")
	isSpawned = false


func player_is_looking_at_watcher(delta):
		enemyTimer -= delta
		timeNotLookedAt = 0.0
		print("Player looking at enemy. Time until kill: ", enemyTimer)
		
func player_is_not_looking_at_watcher(delta):
		timeNotLookedAt += delta
		print("Player not looking at enemy for: ", timeNotLookedAt, " seconds")
