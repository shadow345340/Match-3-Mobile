class_name BoardState
extends Node

# Guardamos una referencia al script principal del tablero
var board: Node2D

# Se ejecuta inmediatamente al entrar a este estado
func enter() -> void:
	pass

# Se ejecuta inmediatamente al salir de este estado
func exit() -> void:
	pass

# Se ejecuta en el _process del tablero si este estado está activo
func update(_delta: float) -> void:
	pass

# Se ejecuta en el _input del tablero si este estado está activo
func handle_input(_event: InputEvent) -> void:
	pass
