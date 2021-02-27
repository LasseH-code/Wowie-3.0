extends Control

export(String) var next_level_scene
#var next_level_scene2

func _ready():
	pass

func _on_next_level(next_level_data):
	next_level_scene = next_level_data

func _on_Continue_pressed():
	#next_level_scene = next_level_scene2
	print(str(next_level_scene))
	get_tree().change_scene(next_level_scene)

func _on_Replay_pressed():
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://_sc/ui/Main_menu.tscn")
