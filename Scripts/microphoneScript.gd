extends Control

@onready var gain_bar = get_node("/root/Node3D/Player/Node3D/MicInput/AudioStreamMicrophone/ProgressBar")
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
	# se verifica que el capture exista y que tenga al menos 1024 muestras
	if capture and capture.can_get_buffer(1024):
	# se obtiene los 1024 muestras del microfono como un array de float
		var buffer = capture.get_buffer(1024)

		if buffer.size() > 0:
			var sum = 0.0 
			for sample in buffer:  # Sumamos el cuadrado de cada muestra (uso de energía)
				sum += sample.length_squared()  

			var rms = sqrt(sum / buffer.size()) # Calculamos el RMS (root mean square = raíz del promedio de los cuadrados)
			var db = 20.0 * log(max(rms, 1e-8)) / log(10.0) # se convierte el rms en decibelios con un logaritmo base 10
			db = clamp(db, -60.0, 0.0) #Se limitan los Db entre -60 (silencio ) y 0 (nivel maximo)
			gain_bar.value = db # Se asignan los decibelios a la ProgressBar
