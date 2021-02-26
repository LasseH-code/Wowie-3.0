extends Node2D

onready var checkpoint_area = $"Area2D"
export onready var player = $"../../Player"
export var id = -1

signal checkpoint(id_data, x_data)

func _ready():
	connect("checkpoint", player , "_on_checkpoint")
	checkpoint_area.monitoring = true

func _on_Area2D_body_entered(body):
	#print (body)
	if body == player:
		emit_signal("checkpoint", id, self.position.x)
