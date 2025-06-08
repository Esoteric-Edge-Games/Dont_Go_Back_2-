extends Node

## Este archivo se va a encargar de gestionar la carga de los JSON, y de guardar los idiomas
## La llamada a este archivo es mediante "Lang". Ej: "Lang.textLanguage" devuelve el idioma actual

var textLanguage = "English"
var soundLanguage = "Espaniol" ## This name has to be EXACTLY equal to folder's name containing that language
var translations = {} ## Dictionary, contains the texts

func _ready():
	load_language()

func change_language(newLang):
	textLanguage = newLang
	load_language()

func change_sound_language(newLang):
	soundLanguage = newLang

func load_language():
	var path = "res://languages/%s/text.json" % textLanguage
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var json = JSON.new()
			var error = json.parse(content)
			if error == OK:
				translations = json.data
			else:
				push_error("ParseError: %s" % json.get_error_message())
		else:
			push_error("Error at opening at: %s" % path)
	else:
		push_error("File not found at %s" % path)

func get_text(section,key):
	##Esta función handlea TODOS los textos del juego y se usa de la siguiente manera:
	## section: La sección de la que se quiere acceder el texto. Ejemplos podrían ser
	## "Death","Intro",etc
	if translations.has(section):
		var entries = translations[section]
		if entries[0].has(key):
			return entries[0][key]
