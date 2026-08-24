class_name FallingState
extends BoardState

func enter() -> void:
	await collapse_columns()
	await refill_board()
	board.state_machine.change_state("MatchingState")

func collapse_columns() -> void:
	for x in board.width:
		for y in range(board.height - 1, -1, -1):
			if board.grid[x][y] == null:
				for k in range(y - 1, -1, -1):
					if board.grid[x][k] != null:
						board.grid[x][y] = board.grid[x][k]
						board.grid[x][k] = null
						board.grid[x][y].grid_position = Vector2i(x, y)
						board.grid[x][y].move_to(board.grid_to_pixel(x, y))
						break
	await get_tree().create_timer(0.3).timeout

func refill_board() -> void:
	for x in board.width:
		for y in board.height:
			if board.grid[x][y] == null:
				board.spawn_at(x, y)
				board.grid[x][y].position.y -= board.offset * 2 
				board.grid[x][y].move_to(board.grid_to_pixel(x, y))
	await get_tree().create_timer(0.3).timeout
