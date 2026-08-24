class_name ScoreManager
extends Node

signal score_changed(new_score: int)
signal moves_changed(moves_left: int)

var target_score: int = 0
var max_moves: int = 0

var current_score: int = 0
var current_moves: int = 0
var board: Node2D

func init(board_reference: Node2D) -> void:
	board = board_reference
	
	var lvl = GameManager.current_level
	
	# EL RETO: El nivel 1 pide 500 puntos. Sube 150 puntos por nivel (Lvl 100 pedirá 15,350)
	target_score = 500 + (lvl * 150)
	
	# MOVIMIENTOS APRETADOS: El nivel 1 te da 20 movimientos. Baja 1 cada 7 niveles (Mínimo 10)
# Cambiado a 7.0 para evitar la advertencia de INTEGER_DIVISION
	max_moves = clampi(20 - (lvl / 7.0), 10, 20)

	
	current_score = 0
	current_moves = max_moves
	
	score_changed.emit(current_score)
	moves_changed.emit(current_moves)

func add_score(matches_count: int) -> void:
	# Volvemos a lo clásico y difícil: 10 puntos por ficha destruida sin multiplicadores raros
	var points = matches_count * 10
	current_score += points
	score_changed.emit(current_score)

func use_move() -> void:
	current_moves -= 1
	moves_changed.emit(current_moves)

func has_moves_left() -> bool:
	return current_moves > 0

func is_target_reached() -> bool:
	return current_score >= target_score
