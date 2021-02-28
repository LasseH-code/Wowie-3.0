extends Node2D

onready var lever_joint = $"LeverJoint"
onready var interaction_area = $"InteractionArea"
onready var input_prompt = $"InputPrompt"

export(NodePath) onready var player = $"../../Player"
onready var logic_reciever = $"../../LogicReciever"
export(int) var id = -1

var interactable = false
export(bool) var active = false
onready var switching_sound = $Switching

signal logic(logic_data, id_data)

func flick_lever():
	if active:
		lever_joint.rotation_degrees = 38
	else:
		lever_joint.rotation_degrees = -38

func _ready():
	interaction_area.monitoring = true
	connect("logic", logic_reciever, "_on_logic")
	flick_lever()

func _input(_event):
	if Input.is_action_just_pressed("interact") and interactable:
		active = !active
		emit_signal("logic", active, id)
		switching_sound.play()
		flick_lever()

func _on_InteractionArea_body_entered(body):
	if body == player:
		input_prompt.show()
		interactable = true

func _on_InteractionArea_body_exited(body):
	if body == player:
		input_prompt.hide()
		interactable = false
