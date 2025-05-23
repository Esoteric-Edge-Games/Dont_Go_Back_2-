extends StaticBody3D

var enemyIsSpawned = false
const TIME_FOR_STALKER_KILLS_PLAYER = 10
var currentTimeNotLookingAtStalker = 0
const TIME_FOR_STALKER_TO_DISSAPEAR = 30
var currentTimeLookingAtStalker = 0
func _ready():
	Global.register_enemy(self)

func spawn_enemy():
	if (enemyIsSpawned): #TODO: Add Stalker limit (Global.canSpawnAntiLookEnemy, etc)
		print("Stalker already spawned!")
		#TODO: Add a func for spawning purpose (Looping on signals/trees, looking for the best one. I still don't know
		#how to determine "the proper one"
		return
	print("stalker spawned")
	enemyIsSpawned = true

func despawn_enemy():
	print("stalker despawned")
	enemyIsSpawned = false
	currentTimeLookingAtStalker = 0
	currentTimeNotLookingAtStalker = 0

func player_dies():
	print("Player died")

func player_is_looking_at_stalker():
	return true if ("playerLookingAtStalker") else false #TODO: Make "playerLookngAtStalker" when model/s is/are ready

func enemy_timers():
	if (player_is_looking_at_stalker()):
		currentTimeLookingAtStalker += 0.1
		if (currentTimeLookingAtStalker > TIME_FOR_STALKER_TO_DISSAPEAR):
			despawn_enemy()
	else:
		currentTimeNotLookingAtStalker += 0.1
		if (currentTimeNotLookingAtStalker > TIME_FOR_STALKER_KILLS_PLAYER):
			player_dies()

func _physics_process(delta):
	if (not enemyIsSpawned):
		return
	enemy_timers()
