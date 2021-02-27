extends Node2D

signal treasureCollected(id_data)

export(int) var id = -1
onready var player = $"../../Player"

func _ready():
	connect("treasureCollected", player, "_on_treasureCollected")

func _on_PickupArea_body_entered(body):
	if body == player:
		emit_signal("treasureCollected", id)
		self.hide()
