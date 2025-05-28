extends Node

#Este autoload principalmente se encarga de gestionar el spawn de enemigos. Cada script de enemigo se regitra al iniciar
#(Ver scripts de enemigos). Cuando la variable enemyToSpawn cambia, a su vez, se llama a _spawn_enemy() lo que llama al respectivo
#nodo. Las condicionse de spawn se encuentran en cada script de archivo

var canSpawnMovementEnemy = true
var canSpawnLookEnemy = true
var canSpawnLightEnemy = true
var canSpawnAntiMovementEnemy = true
var canSpawnAntiLightEnemy = true
var canSpawnAntiLookEnemy = true
var enemyToSpawn = 0
var enemies : Array = []


func register_enemy(enemy):
	enemies.append(enemy)
func _spawn_enemy():
	enemies[enemyToSpawn].spawn_enemy()


## Al poner variables acá, desordeno el flujo del archivo. Pero prefiero esto a mezclar estas variables con las otras

var textLanguage = "English"
var soundLanguage = "Spanish"
