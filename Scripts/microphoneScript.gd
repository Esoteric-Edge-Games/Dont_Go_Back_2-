extends Control

@onready var gain_bar = $AudioStreamMicrophone/ProgressBar
var capture = AudioEffectCapture  
@onready var microphone = get_node("/root/Node3D/Player/Node3D/MicInput/AudioStreamMicrophone")


func _ready():
	microphone.stream = AudioStreamMicrophone.new()
	microphone.bus = "Microphone"
	microphone.play()

	var bus_index = AudioServer.get_bus_index("Microphone")
	AudioServer.set_bus_effect_enabled(bus_index, 0 , true)

	capture = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectCapture


func _process(delta):
	if capture and capture.can_get_buffer(1024):

		var buffer = capture.get_buffer(1024)

		if buffer.size() > 0:
			var sum = 0.0
			for sample in buffer:
				sum += sample.length_squared()  

			var rms = sqrt(sum / buffer.size())
			var db = 20.0 * log(max(rms, 1e-8)) / log(10.0)
			db = clamp(db, -60.0, 0.0)
			gain_bar.value = db
