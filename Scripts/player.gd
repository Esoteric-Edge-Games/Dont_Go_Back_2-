extends CharacterBody3D

@export var mouse_sensitivity := 0.1
@onready var head = $Camera3D



@export var speed = 5.0
var gravity = 20
var delayTimer: Timer
var isSprint = false
var speedWalk = 5.0
var speedRun = 10.0

func _physics_process(delta):
	var direction = Vector3()

	# Dirección relativa a la cámara, opcional
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x

	# Movimiento con WASD
	if Input.is_action_pressed("Move_Forward"):
		direction += forward
	if Input.is_action_pressed("Move_Back"):
		direction -= forward
	if Input.is_action_pressed("Move_Left"):
		direction -= right
	if Input.is_action_pressed("Move_Right"):
		direction += right

	direction.y = 0
	direction = direction.normalized()

	# Aplicar movimiento horizontal
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("Sprint"):
		isSprint = true
		speed = speedRun
		_update_fear(0.5 * get_process_delta_time()) #Not Reduction Fear
		print("Fear ascendiendo:",Global.fear)
		delayTimer.stop() 
	else:
		isSprint = false
		speed = speedWalk
		if delayTimer.is_stopped(): 
			delayTimer.start()


	move_and_slide()

func _update_fear(amount: float):
	Global.fear += amount
	Global.fear = clamp(Global.fear, 0, 100)
	
func _on_delay_timeout():
	Global.fear -= 0.25  #Reduction Fear 
	Global.fear = clamp(Global.fear, 0, 100)
	print("Fear descendiendo:", Global.fear)
	
func _check_game_over():
	if Global.fear >= 100:
		print("Game Over")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Oculta y captura el mouse
	delayTimer = Timer.new()
	delayTimer.wait_time = 0.0
	delayTimer.one_shot = true
	delayTimer.timeout.connect(_on_delay_timeout)
	add_child(delayTimer)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))

		# Limitar la rotación vertical para evitar que gire completamente
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -89, 89)

	# Presionar ESC para liberar el mouse
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
