extends Node2D

signal kill()

onready var kill_area = $KillArea
export onready var player = $"../../../Player"

func _ready():
	connect("kill", player, "_on_kill")
	kill_area.monitoring = true

func _on_KillArea_body_entered(body):
	if body == player:
		emit_signal("kill")
