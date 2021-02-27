extends Node2D

var checkpoints = "Checkpoints/"
# Checkpoint template
#onready var cp = get_node(checkpoints + "")

signal logic_passon(logic_data, id_data)

func _ready():
	# Connection template
	#connect("logic_passon", cp, "_on_logic_passon")
	pass

func _on_logic(logic_data, id_data):
	emit_signal("logic_passon", logic_data, id_data)
