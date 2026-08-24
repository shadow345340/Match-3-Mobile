class_name SwappingState
extends BoardState

var target_a: Vector2i
var target_b: Vector2i

func setup(pos_a: Vector2i, pos_b: Vector2i) -> void:
	target_a = pos_a
	target_b = pos_b

func enter() -> void:
	board.input_handler.is_input_enabled = false
	execute_swap(target_a, target_b)

func execute_swap(a: Vector2i, b: Vector2i) -> void:
	board.swap_pieces(a, b)
	Audio.play("res://sounds/tile-swap.ogg", false, randf_range(0.8, 1.2), 0.3)
	
	await get_tree().create_timer(0.3).timeout
	
	if board.matcher.find_matches().size() > 0:
		# Restamos un movimiento de forma segura al confirmar un match válido
		board.score_manager.use_move()
		board.state_machine.change_state("MatchingState")
	else:
		board.swap_pieces(a, b)
		Audio.play("res://sounds/tile-swap.ogg", false, 2.0, 0.3)
		await get_tree().create_timer(0.3).timeout
		board.state_machine.change_state("IdlingState")
