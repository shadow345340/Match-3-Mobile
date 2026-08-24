class_name VictoryState
extends BoardState

func enter() -> void:
	board.input_handler.is_input_enabled = false
	
	# Mostramos los puntos finales en la ventana y la encendemos
	board.victory_screen.establecer_puntaje(board.score_manager.current_score)
	board.victory_screen.visible = true
	
	Audio.play("res://sounds/tile-land.ogg", false, 1.5, 0.4) # Sonido festivo improvisado
