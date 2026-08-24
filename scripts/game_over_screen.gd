class_name GameOverScreen
extends Control

signal retry_requested
signal menu_requested

@onready var boton_reintentar: Button = $BotonReintentar
@onready var boton_menu: Button = $BotonMenu

func _ready() -> void:
	boton_reintentar.pressed.connect(func(): retry_requested.emit())
	boton_menu.pressed.connect(func(): menu_requested.emit())
