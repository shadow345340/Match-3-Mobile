class_name VictoryScreen
extends Control

signal next_level_requested
signal menu_requested

@onready var puntaje_final: Label = $PuntajeFinal
@onready var boton_siguiente_nivel: Button = $BotonSiguienteNivel
@onready var boton_menu: Button = $BotonMenu

func _ready() -> void:
	boton_siguiente_nivel.pressed.connect(func(): next_level_requested.emit())
	boton_menu.pressed.connect(func(): menu_requested.emit())

func establecer_puntaje(puntos: int) -> void:
	puntaje_final.text = "Puntaje: " + str(puntos)
