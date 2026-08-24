class_name OptionsMenu
extends Control

signal close_requested

@onready var control_musica: HSlider = $VentanaOpciones/ControlMusica
@onready var control_efectos: HSlider = $VentanaOpciones/ControlEfectos
@onready var boton_volver: Button = $VentanaOpciones/BotonVolver

func _ready() -> void:
	if not control_musica.value_changed.is_connected(_on_control_musica_value_changed):
		control_musica.value_changed.connect(_on_control_musica_value_changed)
	
	if not control_efectos.value_changed.is_connected(_on_control_efectos_value_changed):
		control_efectos.value_changed.connect(_on_control_efectos_value_changed)
		
	if not boton_volver.pressed.is_connected(_on_boton_volver_pressed):
		boton_volver.pressed.connect(_on_boton_volver_pressed)
	
	_sync_sliders_with_audio_server()

func _sync_sliders_with_audio_server() -> void:
	var music_idx = AudioServer.get_bus_index("Music")
	var sfx_idx = AudioServer.get_bus_index("SFX")
	
	# Verificación de seguridad por si los nombres en el panel de audio no coinciden exactamente
	if music_idx == -1:
		print("ADVERTENCIA: No se encontró el bus 'Music'. Verifica los nombres en la pestaña Audio.")
		music_idx = AudioServer.get_bus_index("Master")
	if sfx_idx == -1:
		print("ADVERTENCIA: No se encontró el bus 'SFX'. Verifica los nombres en la pestaña Audio.")
		sfx_idx = AudioServer.get_bus_index("Master")
	
	control_musica.value = db_to_linear(AudioServer.get_bus_volume_db(music_idx))
	control_efectos.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_idx))

func _on_control_musica_value_changed(value: float) -> void:
	var music_idx = AudioServer.get_bus_index("Music")
	if music_idx == -1: music_idx = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(value))
	AudioServer.set_bus_mute(music_idx, value < 0.05)

func _on_control_efectos_value_changed(value: float) -> void:
	var sfx_idx = AudioServer.get_bus_index("SFX")
	if sfx_idx == -1: sfx_idx = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_idx, value < 0.05)

func _on_boton_volver_pressed() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, randf_range(0.9, 1.1), 0.3)
	close_requested.emit()
