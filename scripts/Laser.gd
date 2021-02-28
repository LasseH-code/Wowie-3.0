extends Node2D

signal kill()

onready var kill_area = $LaserOn/KillArea
onready var laser_on = $LaserOn
onready var laser_off = $LaserOff
export(NodePath) onready var player = $"../../../Player"

export(bool) var do_logic = false
export(bool) var logic = false
export(int) var logic_id = -1

signal checkpoint(id_data, x_data)

func _on_logic_passon(logic_data, id_data):
	if id_data == logic_id:
		logic = logic_data
	if logic:
		laser_on.show()
		laser_off.hide()
	else:
		laser_on.hide()
		laser_off.show()

func _ready():
	connect("kill", player, "_on_kill")
	kill_area.monitoring = true
	if do_logic:
		if logic:
			laser_on.show()
			laser_off.hide()
		else:
			laser_on.hide()
			laser_off.show()

func _on_KillArea_body_entered(body):
	if do_logic:
		if body == player and logic:
			emit_signal("kill")
	else:
		if body == player:
			emit_signal("kill")
