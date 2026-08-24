class_name SplashScreen
extends Control

@export var next_scene_path: String = "res://scenes/main_menu.tscn"
@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	# Nos conectamos a la señal que avisa cuando el video termina
	video_player.finished.connect(_on_video_finished)

func _input(event: InputEvent) -> void:
	# Si el jugador toca la pantalla en el móvil, se salta el video
	if event is InputEventScreenTouch and event.pressed:
		_change_to_game()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_change_to_game()

func _on_video_finished() -> void:
	_change_to_game()

func _change_to_game() -> void:
	# Cambiamos de escena de forma segura
	get_tree().change_scene_to_file(next_scene_path)
