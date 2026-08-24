class_name PauseMenu
extends Control

signal resume_requested
signal restart_requested
signal exit_requested

@onready var boton_reanudar: Button = $TableroPausa/BotonReanudar
@onready var boton_menu_principal: Button = $TableroPausa/BotonMenuPrincipal
@onready var boton_reiniciar: Button = $TableroPausa/BotonReiniciar

func _ready() -> void:
	# Conectamos las señales a tus botones reales de la imagen
	boton_reanudar.pressed.connect(func(): resume_requested.emit())
	boton_reiniciar.pressed.connect(func(): restart_requested.emit())
	boton_menu_principal.pressed.connect(func(): exit_requested.emit())
