extends Control

onready var player = $"../../../Player"

signal resume()

func _ready():
	connect("resume", player, "_on_resume")

func _on_Resume_pressed():
	emit_signal("resume")
	self.hide()

func _on_Options_pressed():
	pass # Replace with function body.

func _on_MainMenu_pressed():
	get_tree().change_scene("res://_sc/ui/Main_menu.tscn")
