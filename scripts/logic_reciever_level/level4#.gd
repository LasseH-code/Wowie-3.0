extends Node2D

var checkpoints = "Checkpoints/"
var doors = "Doors/"
var lasers = "Lasers/"
# Checkpoint template
#onready var cp = get_node(checkpoints + "")
onready var cp1 = get_node(checkpoints + "Checkpoint")
onready var cp3 = get_node(checkpoints + "Checkpoint3")
# Door template
#onready var d = get_node(doors + "")
onready var d2 = get_node(doors + "Door2")
onready var d3 = get_node(doors + "Door3")
onready var d4 = get_node(doors + "Door4")
onready var d5 = get_node(doors + "Door5")
onready var d6 = get_node(doors + "Door6")
onready var d7 = get_node(doors + "Door7")
onready var d8 = get_node(doors + "Door8")
onready var d9 = get_node(doors + "Door9")
onready var d10 = get_node(doors + "Door10")
# Laser template
#onready var l = get_node(lasers + "")
onready var l1 = get_node(lasers + "Laser")
onready var l2 = get_node(lasers + "Laser2")

signal logic_passon(logic_data, id_data)

func _ready():
	# Connection template
	#connect("logic_passon", cp, "_on_logic_passon")
	connect("logic_passon", cp1, "_on_logic_passon")
	connect("logic_passon", cp3, "_on_logic_passon")
	#connect("logic_passon", d, "_on_logic_passon")
	connect("logic_passon", d2, "_on_logic_passon")
	connect("logic_passon", d3, "_on_logic_passon")
	connect("logic_passon", d4, "_on_logic_passon")
	connect("logic_passon", d5, "_on_logic_passon")
	connect("logic_passon", d6, "_on_logic_passon")
	connect("logic_passon", d7, "_on_logic_passon")
	connect("logic_passon", d8, "_on_logic_passon")
	connect("logic_passon", d9, "_on_logic_passon")
	connect("logic_passon", d10, "_on_logic_passon")
	#connect("logic_passon", l, "_on_logic_passon")
	connect("logic_passon", l1, "_on_logic_passon")
	connect("logic_passon", l2, "_on_logic_passon")
	#pass

func _on_logic(logic_data, id_data):
	emit_signal("logic_passon", logic_data, id_data)
