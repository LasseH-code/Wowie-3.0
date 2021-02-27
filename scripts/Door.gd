extends Node2D

onready var closed = $DoorClosed
onready var open = $DoorOpen
onready var collision = $StaticBody2D/CollisionShape2D

export(bool) var do_logic = false
export(bool) var logic = false
export(int) var logic_id = -1

func _on_logic_passon(logic_data, id_data):
	if id_data == logic_id:
		logic = logic_data
		if !logic:
			closed.visible = true
			open.visible = false
			collision.disabled = false
		else:
			closed.visible = false
			open.visible = true
			collision.disabled = true

func _ready():
	pass
