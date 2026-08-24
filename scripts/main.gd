class_name Match3Board
extends Node2D

@export_subgroup("Properties")
@export var width: int = 8
@export var height: int = 8
@export var offset: int = 68

@export_subgroup("Scenes")
@export var tile_scene: PackedScene 
@export_subgroup("Particles")
@export var sparkles_scene: PackedScene

@export_subgroup("Tiles")
@export var textures: Array[Texture2D] 

@export_subgroup("Cursors")
@export var open_hand_cursor: Texture2D
@export var closed_hand_cursor: Texture2D

@onready var container: Node2D = $Board
@onready var state_machine: BoardStateMachine = $StateMachine
@onready var input_handler: InputHandler = $Components/InputHandler
@onready var matcher: GridMatcher = $Components/GridMatcher
@onready var score_manager: ScoreManager = $Components/ScoreManager

@onready var pause_button: TextureButton = $GameUI/PauseButton
@onready var pause_menu: PauseMenu = $GameUI/PauseMenu
@onready var valor_puntos: Label = $GameUI/ValorPuntos
@onready var valor_movimientos: Label = $GameUI/ValorMovimientos
@onready var victory_screen: VictoryScreen = $GameUI/VictoryScreen
@onready var game_over_screen: GameOverScreen = $GameUI/GameOverScreen

var grid: Array = []
var combo_count: int = 0

func _ready() -> void:
	set_cursor(open_hand_cursor)
	randomize()
	
	input_handler.init(self)
	matcher.init(self)
	score_manager.init(self)
	
	setup_grid_array() 
	center_grid_on_screen() 
	get_viewport().size_changed.connect(center_grid_on_screen)
	
	state_machine.init(self)
	input_handler.swipe_detected.connect(_on_swipe_detected)
	
	score_manager.score_changed.connect(_on_score_updated)
	score_manager.moves_changed.connect(_on_moves_updated)
	
	pause_menu.visible = false
	pause_button.pressed.connect(_on_pause_button_pressed)
	pause_menu.resume_requested.connect(_on_resume_game)
	pause_menu.restart_requested.connect(_on_restart_game)
	pause_menu.exit_requested.connect(_on_exit_to_menu)
	
	victory_screen.visible = false
	game_over_screen.visible = false
	
	# Configurar botones finales
	victory_screen.next_level_requested.connect(_on_next_level_loaded)
	victory_screen.menu_requested.connect(_on_exit_to_menu)
	
	game_over_screen.retry_requested.connect(_on_restart_game)
	game_over_screen.menu_requested.connect(_on_exit_to_menu)

func _on_score_updated(new_score: int) -> void:
	# Formato sencillo de 3 dígitos (ej: Puntos: 030 / Puntos: 150)
	# Mostramos también la meta actual calculada dinámicamente
	valor_puntos.text = "Puntos: %03d / %03d" % [new_score, score_manager.target_score]

func _on_moves_updated(moves_left: int) -> void:
	valor_movimientos.text = "Lvl %d - Movs: %d" % [GameManager.current_level, moves_left]

func _on_next_level_loaded() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, 1.0, 0.3)
	
	GameManager.current_level = clampi(GameManager.current_level + 1, 1, 100)
	GameManager.save_game()
	
	# Usamos call_deferred para evitar el crash de 'data.tree is null'
	get_tree().call_deferred("reload_current_scene")

func center_grid_on_screen() -> void:
	var view_size = get_viewport_rect().size
	$Background.offset_right = view_size.x
	$Background.offset_bottom = view_size.y
	container.position = view_size / 2.0 - Vector2(width - 1, height - 1) * offset / 2.0

func setup_grid_array() -> void:
	grid = []
	for x in width:
		grid.append([])
		grid[x].resize(height)
		grid[x].fill(null)
		
	for x in width:
		for y in height:
			spawn_at(x, y)

func spawn_at(x: int, y: int) -> void:
	var created_piece = tile_scene.instantiate() 
	var random_index = randi_range(0, textures.size() - 1)
	
	container.add_child(created_piece) 
	
	created_piece.set_tile_type(str(random_index), textures[random_index]) 
	created_piece.tile_pressed.connect(input_handler.handle_tile_pressed) 
	created_piece.grid_position = Vector2i(x, y) 
	created_piece.position = grid_to_pixel(x, y) 
	
	grid[x][y] = created_piece

func _on_swipe_detected(from_pos: Vector2i, to_pos: Vector2i) -> void:
	if state_machine.current_state.name == "IdlingState":
		var swapping_state = state_machine.states["swappingstate"]
		swapping_state.setup(from_pos, to_pos)
		state_machine.change_state("SwappingState")

func swap_pieces(a: Vector2i, b: Vector2i) -> void:
	var piece_a = grid[a.x][a.y]
	var piece_b = grid[b.x][b.y]
	
	if piece_a and piece_b:
		grid[a.x][a.y] = piece_b
		grid[b.x][b.y] = piece_a
		
		piece_a.grid_position = b
		piece_b.grid_position = a
		
		piece_a.move_to(grid_to_pixel(b.x, b.y), false)
		piece_b.move_to(grid_to_pixel(a.x, a.y), false)

func grid_to_pixel(column: int, row: int) -> Vector2:
	return Vector2(offset * column, offset * row)

func set_cursor(cursor_texture: Texture2D) -> void:
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(16, 16))

func _on_pause_button_pressed() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, 1.0, 0.3)
	pause_menu.visible = true
	get_tree().paused = true

func _on_resume_game() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, 1.1, 0.3)
	pause_menu.visible = false
	get_tree().paused = false

func _on_restart_game() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, 1.0, 0.3)
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene") # Corregido con call_deferred

func _on_exit_to_menu() -> void:
	Audio.play("res://sounds/tile-swap.ogg", false, 0.9, 0.3)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
