extends Node2D

onready var area = $Area2D
onready var player = $"../../Player"
onready var camera = $"../../Camera"

export(bool) var do_logic = false
export(bool) var logic = false
export(int) var logic_id = -1

signal win()

func _ready():
	connect("win", player, "_on_win")
	connect("win", camera, "_on_win")
	area.monitoring = true

func _on_logic_passon(logic_data, id_data):
	if id_data == logic_id:
		logic = logic_data

func _on_Area2D_body_entered(body):
	if body == player:
		if !do_logic:
			emit_signal("win")
		elif logic:
			emit_signal("win")
