extends Node2D

onready var checkpoint_area = $"Area2D"
export(NodePath) onready var player = $"../../Player"
export(int) var id = -1
export(bool) var do_logic = false
export(bool) var logic = false

signal checkpoint(id_data, x_data)

func _on_logic(logic_data):
	logic = logic_data

func _ready():
	connect("checkpoint", player , "_on_checkpoint")
	checkpoint_area.monitoring = true

func _on_Area2D_body_entered(body):
	#print (body)
	if do_logic:
		if logic:
			if body == player:
				emit_signal("checkpoint", id, self.position.x)
	else:
		if body == player:
			emit_signal("checkpoint", id, self.position.x)
