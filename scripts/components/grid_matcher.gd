class_name GridMatcher
extends Node

var board: Node2D

func init(board_reference: Node2D) -> void:
	board = board_reference

func is_within_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < board.width and pos.y >= 0 and pos.y < board.height

func find_matches() -> Array:
	var matched_dict = {}

	for y in board.height:
		for x in range(board.width - 2):
			var p1 = board.grid[x][y]
			var p2 = board.grid[x+1][y]
			var p3 = board.grid[x+2][y]
			if p1 and p2 and p3 and p1.type == p2.type and p1.type == p3.type:
				for p in [p1, p2, p3]: matched_dict[p] = true

	for x in board.width:
		for y in range(board.height - 2):
			var p1 = board.grid[x][y]
			var p2 = board.grid[x][y+1]
			var p3 = board.grid[x][y+2]
			if p1 and p2 and p3 and p1.type == p2.type and p1.type == p3.type:
				for p in [p1, p2, p3]: matched_dict[p] = true

	return matched_dict.keys()
