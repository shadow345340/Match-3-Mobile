class_name MatchingState
extends BoardState

func enter() -> void:
	var matches = board.matcher.find_matches()
	if matches.size() > 0:
		board.combo_count += 1
		Audio.play("res://sounds/tile-match.ogg", true, 1.0 + (board.combo_count * 0.1))
		
		# Sumar puntuación basada en la cantidad de fichas combinadas
		board.score_manager.add_score(matches.size())
		
		for piece in matches:
			var effect = board.sparkles_scene.instantiate()
			effect.position = piece.position
			board.container.add_child(effect)
			
			board.grid[piece.grid_position.x][piece.grid_position.y] = null
			
			var tween = piece.create_tween()
			tween.tween_property(piece, "scale", Vector2.ZERO, 0.2)
			tween.finished.connect(piece.queue_free)
			
		await get_tree().create_timer(0.3).timeout
		board.state_machine.change_state("FallingState")
	else:
		# El tablero está en reposo y se procesaron todas las caídas en cadena
		_check_game_conditions()

func _check_game_conditions() -> void:
	# 1. Condición de Victoria inmediata si alcanzas la puntuación meta
	if board.score_manager.is_target_reached():
		board.state_machine.change_state("VictoryState")
		return
		
	# 2. Si no has ganado y ya no te quedan movimientos, vas a GameOver
	if not board.score_manager.has_moves_left():
		board.state_machine.change_state("GameOverState")
		return
		
	# 3. Si te quedan movimientos y no has llegado a la meta, sigues jugando
	board.state_machine.change_state("IdlingState")
