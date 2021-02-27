extends Node2D

onready var lever_joint = $"LeverJoint"
onready var interaction_area = $"InteractionArea"
onready var input_prompt = $"InputPrompt"

export(NodePath) onready var player = $"../../Player"
export(NodePath) onready var logic_reciever = $"../"

var interactable = false
export(bool) var active = false

signal logic(logic_data)

func _ready():
	interaction_area.monitoring = true
	connect("logic", logic_reciever, "_on_logic")

func _input(event):
	if Input.is_action_pressed("interact"):
		active = !active
		emit_signal("logic", active)

func _on_InteractionArea_body_entered(body):
	if body == player:
		input_prompt.show()
		interactable = true

func _on_InteractionArea_body_exited(body):
	if body == player:
		input_prompt.hide()
		interactable = false
