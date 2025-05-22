""" 
El Runner es la placa continental del gameplay ya que sostiene el hecho de que no puedas retroceder 
el mismo tendrá ataques como el resto pero su verdadera finalidad es que no regreses, ya que con una 
serie de X cantidad de pasos el mismo te atacará obligándome a correr en la dirección contraria o 
afrontar la muerte.
si se corre hasta un lugar iluminado el mismo será un punto seguro hasta que la luz se apague

TODO
Tipo : movimiento, iluminación 
anti tipo : anti movimiento, observación.
Arquetipo: Hostil

Movimiento : Te obliga a moverte de tu lugar. No ataca si estás bajo un poste de luz a no ser que este se apague.
Iluminación: Te obliga a moverte a un lugar iluminado por al menos 3 segundos.
 
Anti movimiento : Te obliga a quedarte quieto
anti observación : te obliga dejar de mirar
"""

extends StaticBody3D

# Define the class
class luz:
	var my_property
	func _init(value):
		my_property = value
	func my_method():
		print(my_property)


func _ready():
	Global.register_enemy(self)

func spawn_enemy():
	print("enemigo 2 spawneado")
