extends Node3D

@onready var player = get_node("/root/Node3D/Player")
@onready var owlTimer = $Owl/OwlTimer.time_left
@onready var owl = $Owl
@onready var irons = $Irons
var posicion = [Vector3(30, 0, 0), Vector3(-30, 0, 0) ]

func _ready():
	for node in get_children():
		for sound in node.get_children():
			sound.timeout.connect(_on_timer_timeout.bind(node))

func _on_timer_timeout(soundNode):
	soundNode.position = player.position + posicion[randi() % posicion.size()]
	soundNode.play()
