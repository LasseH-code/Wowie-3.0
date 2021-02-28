extends Node2D

var checkpoints = "Checkpoints/"
var doors = "Doors/"
var lasers = "Lasers/"
# Checkpoint template
#onready var cp = get_node(checkpoints + "")
# Door template
#onready var d = get_node(doors + "")
# Laser template
#onready var l = get_node(lasers + "")

signal logic_passon(logic_data, id_data)

func _ready():
	# Connection template
	#connect("logic_passon", cp, "_on_logic_passon")
	#connect("logic_passon", d, "_on_logic_passon")
	#connect("logic_passon", l, "_on_logic_passon")
	pass

func _on_logic(logic_data, id_data):
	emit_signal("logic_passon", logic_data, id_data)
