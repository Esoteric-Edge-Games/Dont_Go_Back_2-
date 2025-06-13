extends StaticBody3D

#Variables y constancias que hacen que el enemigo "Watcher" spawnee
@onready var cameraPlayer = get_node("/root/Node3D/Player/Node3D/Camera3D")
@onready var player = get_node("/root/Node3D/Player")
@onready var watcherFlying = get_node("/root/Node3D/Watcher/Watcher/AnimationPlayer")

var watcherAppears = false 
var player_looking_watcher = false
var player_not_looking_watcher = false

const ENEMY_DURATION = 3.0
var enemyTimer = ENEMY_DURATION
var timeNotLookedAt = 0.0
const NOT_LOOK_THRESHOLD = 3.0

var orbit_angle = 0.0  # Radianes
var orbit_speed = 0.55 # rotation velocity
var orbit_radius = 5.0  # how far orbit the player


func _physics_process(delta):
	
	
	if watcherAppears:
		watcherFlying.play("Flying")
		
		# this code make the watcher orbit the player 
		orbit_angle += orbit_speed * delta
		var playerPosition = player.global_transform.origin 
		var x = cos(orbit_angle) * orbit_radius
		var z = sin(orbit_angle) * orbit_radius
		var enemy_pos = player.global_transform.origin + Vector3(x, 2.5, z)
		# Movimiento suave hacia la nueva posición
		global_transform.origin = global_transform.origin.lerp(enemy_pos, delta * 5.0)
		# the watcher looks the player
		look_at(playerPosition, Vector3.UP)
		
		# this code make when the watcher spawn, appears in front of the player 
		var camera_forward = -cameraPlayer.global_transform.basis.z.normalized()
		var to_enemy = (global_transform.origin - cameraPlayer.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_enemy)
		if dot_value > 0.95:
			player_is_looking_at_watcher(delta)

		else:
			player_is_not_looking_at_watcher(delta)

		if enemyTimer <= 0.0:
			print("Watcher kills the player")

		if timeNotLookedAt >= NOT_LOOK_THRESHOLD:
			enemy_dissapear()
		dragg_camera(delta)


func dragg_camera(delta):
	#This code make the camera dragg to the watcher
	cameraPlayer.focus_on_watcher(self)

func watcher_is_in_front_of_the_player():
	watcherAppears = true
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0

func enemy_dissapear():
	print("Enemy disappears because player did not look")
	watcherFlying.stop()
	restore_vars()

func player_is_looking_at_watcher(delta):
	# If the player is looking the Watcher and the "enemyTimer" is equals 0.0, the player will die
	enemyTimer -= delta
	timeNotLookedAt = 0.0
	print("Player looking at enemy. Time until kill: ", enemyTimer)

func player_is_not_looking_at_watcher(delta):
	# if the player is dont looking the watcher, the watcher will disappear
	timeNotLookedAt += delta
	print("Player not looking at enemy for: ", timeNotLookedAt, " seconds")

func restore_vars():
	# this restore the variables for a future spawn of the watcher
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0
	global_transform.origin = Vector3(9999, 9999, 0)
	cameraPlayer.unfocus_on_watcher()
	watcherAppears = false
	player_looking_watcher = false
	player_not_looking_watcher = false

func _ready():
	Global.register_enemy(self)

func spawn_enemy():
	if not watcherAppears:
		global_transform.origin = Vector3(player.global_transform.origin.x,90, player.global_transform.origin.z)
		watcherAppears = true
	print("Watcher Spawneado")
