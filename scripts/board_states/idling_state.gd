class_name IdlingState
extends BoardState

func enter() -> void:
	board.input_handler.is_input_enabled = true
	board.combo_count = 0

func handle_input(event: InputEvent) -> void:
	board.input_handler.process_input(event)
