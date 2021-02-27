extends Node2D

onready var area = $Area2D
export(NodePath) onready var player = $"../Player"
export(NodePath) onready var camera = $"../Camera"

signal win()

func _ready():
	connect("win", player, "_on_win")
	connect("win", camera, "_on_win")
	area.monitoring = true

func _on_Area2D_body_entered(body):
	emit_signal("win")
