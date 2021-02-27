extends Control

#onready var continue_button = $"Button Container/Continue"
#onready var new_game_button = $"Button Container/New Game"
#onready var options_button = $"Button Container/Options"
#onready var test_world_button = $TestWorld

func _ready():
	pass

func _on_Continue_pressed():
	pass # Replace with function body.

func _on_New_Game_pressed():
	pass # Replace with function body.

func _on_Options_pressed():
	pass # Replace with function body.

func _on_TestWorld_pressed():
	get_tree().change_scene("res://_sc/level/level1.tscn")
