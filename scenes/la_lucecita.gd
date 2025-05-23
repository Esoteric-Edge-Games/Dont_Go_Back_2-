extends DirectionalLight3D  

class_name LightPost  

var timer: Timer
var is_on: bool = false

func _ready():
	timer = Timer.new()
	timer.wait_time = 5.0
	timer.connect("timeout", self, "_toggle_light")
	add_child(timer)  

func start_timer():
	timer.start()

func stop_timer():
	timer.stop()

func _toggle_light():
	is_on = !is_on
