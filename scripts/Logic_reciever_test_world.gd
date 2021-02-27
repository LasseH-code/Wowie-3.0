extends Node2D

var checkpoints = "Checkpoints/"
onready var cp1 = get_node(checkpoints + "Checkpoint")

# Not actually Logically active
#onready var cp2 = get_node(checkpoints + "Checkpoint2")
#onready var cp3 = get_node(checkpoints + "Checkpoint3")

onready var goal = $"Goal"

var doors = "Doors/"
onready var d1 = get_node(doors + "Door")

signal logic_passon(logic_data, id_data)

func _ready():
	connect("logic_passon", cp1, "_on_logic_passon")
	
	connect("logic_passon", goal, "_on_logic_passon")
	
	connect("logic_passon", d1, "_on_logic_passon")

func _on_logic(logic_data, id_data):
	emit_signal("logic_passon", logic_data, id_data)
