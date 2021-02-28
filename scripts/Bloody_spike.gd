extends Node2D

signal kill()

onready var kill_area = $KillArea
export(NodePath) onready var player = $"../../Player"
onready var particles = $DeathParticles/CPUParticles2D

func _ready():
	connect("kill", player, "_on_kill")
	kill_area.monitoring = true

func _on_KillArea_body_entered(body):
	if body == player:
		particles.emitting = true
		emit_signal("kill")
