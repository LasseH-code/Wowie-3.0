extends Node2D

signal kill()

export(NodePath) onready var player = $"../../Player"
onready var kill_area1 = $"Spike/KillArea"
onready var kill_area2 = $"Spike2/KillArea"
onready var kill_area3 = $"Spike3/KillArea"
onready var kill_area4 = $"Spike4/KillArea"

func _ready():
	connect("kill", player, "_on_kill")
	kill_area1.monitoring = true
	kill_area2.monitoring = true
	kill_area3.monitoring = true
	kill_area4.monitoring = true

func _on_KillArea_body_entered(body):
	if body == player:
		emit_signal("kill")
