extends DirectionalLight3D  

class_name LightPost  

var timer: Timer
var is_on: bool = false
var position_list: Array = [] 

func _ready():
	timer = Timer.new()
	timer.wait_time = 5.0
	timer.timeout.connect(_toggle_light)
	add_child(timer)  
	position_list.append(global_position)

func start_timer():
	timer.start()

func stop_timer():
	timer.stop()

func _toggle_light():
	is_on = !is_on
	
func get_positions() -> Array:
	return position_list
