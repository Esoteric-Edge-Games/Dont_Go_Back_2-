extends Control

@onready var gain_bar = get_node("/root/Node3D/Player/MicInput/AudioStreamMicrophone/ProgressBar")
var capture = AudioEffectCapture #AudioServer.get_bus_effect(bus_index, 0) 
@onready var microphone = get_node("/root/Node3D/Player/Node3D/MicInput/AudioStreamMicrophone")


func _ready():
	microphone.stream = AudioStreamMicrophone.new()
	microphone.bus = "MicCaptureBus"
	microphone.play()
	
	
	var bus_index = AudioServer.get_bus_index("MicroInput")
	AudioServer.set_bus_effect_enabled(bus_index, 0 , true)
	
	capture = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectCapture
	print("Capture: ", capture)



func _process(delta):
	if capture and capture.can_get_buffer(1024):
		print("Puede Obtener Buffer")
		var buffer = capture.get_buffer(1024)
		if buffer.size() > 0:
			var sum = 0.0
			for sample in buffer:
				sum += sample.length_squared()  # porque es Vector2

			var rms = sqrt(sum / buffer.size())
			var db = 20.0 * log(max(rms, 1e-8)) / log(10.0)
			db = clamp(db, -60.0, 0.0)
			gain_bar.value = db
			print("db: ", db)
