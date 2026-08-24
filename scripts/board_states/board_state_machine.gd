class_name BoardStateMachine
# res://scripts/board_states/board_state_machine.gd
extends Node

signal state_changed(new_state_name: String)

@export var initial_state: NodePath

var current_state: Node = null
var states: Dictionary = {}

func init(board_reference: Node2D) -> void:
	# Buscamos todos los nodos hijos que sean estados
	for child in get_children():
		if child.has_method("enter"):
			child.board = board_reference
			states[child.name.to_lower()] = child
	
	# Inicializamos el estado por defecto
	if initial_state:
		change_state(get_node(initial_state).name)

func change_state(new_state_name: String) -> void:
	var state_key = new_state_name.to_lower()
	if not states.has(state_key):
		push_error("El estado '" + new_state_name + "' no existe en la máquina de estados.")
		return
		
	if current_state:
		current_state.exit()
		
	current_state = states[state_key]
	current_state.enter()
	state_changed.emit(current_state.name)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
