extends Node2D

signal treasureCollected(id_data)

export(int) var id = -1
onready var player = $"../../Player"
onready var pickup_audio = $Pickup

func _ready():
	connect("treasureCollected", player, "_on_treasureCollected")

func _on_PickupArea_body_entered(body):
	if body == player and self.visible:
		emit_signal("treasureCollected", id)
		pickup_audio.play()
		self.hide()
