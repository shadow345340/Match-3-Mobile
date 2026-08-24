class_name InputHandler
extends Node

signal swipe_detected(from_pos: Vector2i, to_pos: Vector2i)

var board: Node2D
var first_touch: Vector2i = Vector2i(-1, -1)
var is_input_enabled: bool = true

func init(board_reference: Node2D) -> void:
	board = board_reference

func handle_tile_pressed(grid_position: Vector2i) -> void:
	if not is_input_enabled:
		return
	first_touch = grid_position
	board.set_cursor(board.closed_hand_cursor)

func process_input(event: InputEvent) -> void:
	if not is_input_enabled:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if first_touch != Vector2i(-1, -1):
				var local_mouse_pos = board.container.get_local_mouse_position()
				calculate_swipe(local_mouse_pos)

func calculate_swipe(final_pos: Vector2) -> void:
	var origin_pixel = board.grid_to_pixel(first_touch.x, first_touch.y)
	var difference = final_pos - origin_pixel
	
	if difference.length() > 32:
		var other_touch = first_touch
		if abs(difference.x) > abs(difference.y):
			other_touch.x += 1 if difference.x > 0 else -1
		else:
			other_touch.y += 1 if difference.y > 0 else -1
		
		if board.matcher.is_within_grid(other_touch):
			swipe_detected.emit(first_touch, other_touch)
	
	board.set_cursor(board.open_hand_cursor)
	first_touch = Vector2i(-1, -1)
