extends Node3D
const TOTAL_ENEMIES = 3 #We can adjust de % of every enemy on the switch on autoload.gd
var RNG = RandomNumberGenerator.new()

var timer = 0

func _ready():
	Global.enemyToSpawn = -1
	
func _process(delta):
	timer += 0.1
	if (timer >= 15):
		Global.enemyToSpawn = int(RNG.randf_range(0,TOTAL_ENEMIES))
		print(Lang.get_text("test","firstText"))
		timer = 0
		Global._spawn_enemy()
