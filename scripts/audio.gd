extends Node

var num_players = 12
var available = []
var queue = []
var active_sounds = {}

# Nodo dedicado exclusivamente para la música de fondo
var music_player: AudioStreamPlayer

func _ready():
	# 1. Configurar reproductor de música de fondo en el bus "Music"
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	
	# Cargamos tu canción de 29 segundos de forma segura
	var cancion = load("res://music/musiquita.mp3")
	if cancion:
		music_player.stream = cancion
		
		# Forzamos el bucle/loop infinito de la forma más directa posible en Godot 4
		if music_player.stream.has_method("set_loop"):
			music_player.stream.set_loop(true)
		elif "loop" in music_player.stream:
			music_player.stream.loop = true
		
		music_player.volume_db = -6
		music_player.play()

	# 2. Configurar efectos de sonido en el bus "SFX"
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.volume_db = -10
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = "SFX"

func _on_stream_finished(player):
	for path in active_sounds.keys():
		if active_sounds[path].has(player):
			active_sounds[path].erase(player)
			if active_sounds[path].is_empty():
				active_sounds.erase(path)
			break
	available.append(player)

func play(sound_path: String, allow_overlap: bool = false, pitch: float = 1.0, volume: float = 1.0):
	if allow_overlap:
		queue.append({"path": sound_path, "overlap": true, "pitch": pitch, "volume": volume})
	else:
		if not active_sounds.has(sound_path) and not _is_in_queue(sound_path):
			queue.append({"path": sound_path, "overlap": false, "pitch": pitch, "volume": volume})

func _is_in_queue(sound_path: String) -> bool:
	for item in queue:
		if item["path"] == sound_path:
			return true
	return false

func _process(_delta):
	if not queue.is_empty() and not available.is_empty():
		var data = queue.pop_front()
		var sound_path = data["path"]
		var player = available[0]
		available.pop_front()
		
		if not data["overlap"]:
			if not active_sounds.has(sound_path):
				active_sounds[sound_path] = []
			active_sounds[sound_path].append(player)
		
		player.stream = load(sound_path)
		player.pitch_scale = data["pitch"]
		player.volume_db = linear_to_db(data["volume"])
		
		# FORCE BUS: Nos aseguramos al 100% que use el canal de Efectos
		player.bus = "SFX"
		
		player.play()

func linear_to_db(linear: float) -> float:
	if linear > 0:
		return 20.0 * log(linear) / log(10.0)
	return -80.0
