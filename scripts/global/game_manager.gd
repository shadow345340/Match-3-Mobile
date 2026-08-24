extends Node

const SAVE_FILE_PATH = "user://match3_savegame.save"

var current_level: int = 1

func _ready() -> void:
	# Intentamos cargar el progreso del jugador inmediatamente al abrir el juego
	load_game()

# Función para guardar el progreso en el almacenamiento interno del dispositivo
func save_game() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		# Guardamos el nivel actual convertido en una línea de texto segura
		file.store_line(str(current_level))
		file.close()
		print("Juego Guardado Exitosamente. Nivel actual: ", current_level)

# Función para cargar el progreso desde la memoria
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		current_level = 1 # Si no hay archivo guardado (primera partida), inicia en el nivel 1
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_line()
		if content.is_valid_int():
			current_level = clampi(content.to_int(), 1, 100)
			print("Progreso Cargado Exitosamente. Retomando Nivel: ", current_level)
		file.close()
