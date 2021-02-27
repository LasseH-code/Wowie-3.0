extends Control

export(String) var next_level_scene
#var next_level_scene2

onready var star2 = $"ButtonContainer/Node2D/Sprite2"
onready var star3 = $"ButtonContainer/Node2D/Sprite3"

func _ready():
	pass

func _on_setup_win(next_level_data, treasure1_data, treasure2_data):
	next_level_scene = next_level_data
	if treasure1_data:
		star2.show()
	if treasure2_data:
		star3.show()

func _on_Continue_pressed():
	#next_level_scene = next_level_scene2
	print(str(next_level_scene))
	get_tree().change_scene(next_level_scene)

func _on_Replay_pressed():
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://_sc/ui/Main_menu.tscn")
