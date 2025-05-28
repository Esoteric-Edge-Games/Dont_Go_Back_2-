extends CharacterBody3D

@export var mouse_sensitivity := 0.1
@onready var head = $Camera3D



@export var speed = 5.0
var gravity = 20

var isSprint = false
var speedWalk = 5.0
var speedRun = 10.0
var limitForReset = -12 #I'll be using Z-position because is where camera is facing. Can be changed later

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
	else:
		isSprint = false
		speed = speedWalk

	move_and_slide()
	check_reset()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Oculta y captura el mouse

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))

		# Limitar la rotación vertical para evitar que gire completamente
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -89, 89)

	# Presionar ESC para liberar el mouse
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func check_reset():
	if global_transform.origin.z <= limitForReset: #Change "z" if wanted
		global_transform.origin.z = 0
