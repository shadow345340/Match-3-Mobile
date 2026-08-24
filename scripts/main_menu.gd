class_name MainMenu
extends Control

@export var game_scene_path: String = "res://scenes/main.tscn"

@onready var play_button: Button = $MarginContainer/CanvasLayer/PanelContainer/CenterContainer/ButtonsContainer/PlayButton
@onready var options_button: Button = $MarginContainer/CanvasLayer/PanelContainer/CenterContainer/ButtonsContainer/OptionsButton
@onready var quit_button: Button = $MarginContainer/CanvasLayer/PanelContainer/CenterContainer/ButtonsContainer/QuitButton

@onready var options_menu: OptionsMenu = $MarginContainer/CanvasLayer/OptionsMenu

func _ready() -> void:
	options_menu.visible = false
	options_menu.close_requested.connect(_on_close_options_requested)
	
	if options_button.pressed.is_connected(_on_play_button_pressed):
		options_button.pressed.disconnect(_on_play_button_pressed)
	
	if not options_button.pressed.is_connected(_on_options_button_pressed):
		options_button.pressed.connect(_on_options_button_pressed)
	
	if OS.get_name() in ["Android", "iOS"]:
		quit_button.visible = false

func _on_play_button_pressed() -> void:
	_play_click_sound()
	get_tree().change_scene_to_file(game_scene_path)

func _on_options_button_pressed() -> void:
	_play_click_sound()
	options_menu.visible = true
	options_menu.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(options_menu, "modulate:a", 1.0, 0.2)

func _on_close_options_requested() -> void:
	var tween = create_tween()
	tween.tween_property(options_menu, "modulate:a", 0.0, 0.15)
	await tween.finished
	options_menu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _play_click_sound() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, randf_range(0.9, 1.1), 0.3)
