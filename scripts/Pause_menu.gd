extends Control

onready var player = $"../../../Player"

signal resume()

func _on_player(player_data):
	player = player_data

func _ready():
	pass

func _on_Resume_pressed():
	connect("resume", player, "_on_resume")
	emit_signal("resume")
	self.hide()

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Reset_pressed():
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://_sc/ui/Main_menu.tscn")
