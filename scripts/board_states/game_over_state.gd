class_name GameOverState
extends BoardState

func enter() -> void:
	board.input_handler.is_input_enabled = false
	
	# Encendemos la pantalla de derrota
	board.game_over_screen.visible = true
	
	Audio.play("res://sounds/tile-swap.ogg", false, 0.5, 0.4) # Sonido triste improvisado
