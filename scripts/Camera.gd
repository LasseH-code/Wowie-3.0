extends Camera2D

const MIN_X = 590
const MAX_X = 2000 

export(NodePath) onready var x_follow_target = $"../Player"
onready var crt = $"CanvasLayer/ColorRect"
onready var pause_menu = $"HUD/PauseMenu"
onready var win_splashscreen = $"HUD/WinSplashscreen"
export(NodePath) onready var player = $"../Player"
export(String) var next_level

var target_last_tick = Vector2(0, 0)
var relative_target_position = Vector2()

var dir = Vector2()
var vel = Vector2()
var relative_mouse_position = Vector2()
const SPEED_MULTIPLYER = 1.0
const ACCELERATION = 5.0
const DECELLERATION = 5.0
var won = false

signal player(player_data)
signal next_level(next_level_data)

func _on_camera_reset():
	self.position.x = MIN_X

func _on_win():
	won = true
	win_splashscreen.show()

func _physics_process(_delta):
	if x_follow_target.position.x >= MIN_X and x_follow_target.position.x <= MAX_X:
		self.position.x = x_follow_target.position.x
		relative_target_position = x_follow_target.position - target_last_tick
		crt.rect_position.x += relative_target_position.x/1.2
	target_last_tick = x_follow_target.position

func update_mouse_position(event):
	if event is InputEventMouseMotion:
		relative_mouse_position = event.relative

func _input(event):
	if won != true:
		if Input.is_action_just_released("ui_cancel"):
			pause_menu.visible = !pause_menu.visible

# procsss_input and process_movement not suited for this unless heavily modded
func process_input(delta):
	dir = Vector3()
	var camera_xform = self.get_global_transform()
	
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("edit_rotate_camera") and Input.is_action_pressed("edit_slide_camera"):
		if relative_mouse_position.x > 0:
			input_movement_vector.x -= 1
		if relative_mouse_position.x < 0:
			input_movement_vector.x -= 1
		if relative_mouse_position.y > 0:
			input_movement_vector.y -= 1
		if relative_mouse_position.y < 0:
			input_movement_vector.y -= 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -camera_xform.basis.y * input_movement_vector.y
	dir += camera_xform.basis.x * input_movement_vector.x

func process_movement(delta):
	dir.z = 0
	dir = dir.normalized()
	
	var hvel = vel
	hvel.z = 0
	
	var target = dir
	#target *= max(relative_mouse_position.x, relative_mouse_position.y)
	target.x *= relative_mouse_position.x * SPEED_MULTIPLYER
	target.y *= relative_mouse_position.y * SPEED_MULTIPLYER
	
	var acceleration
	acceleration = ACCELERATION
	if dir.dot(hvel) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELLERATION
	
	hvel = hvel.linear_interpolate(target, acceleration * delta)
	vel.x = hvel.x
	vel.y = hvel.y
	#vel = self.move_and_slide(vel)
	relative_mouse_position = Vector2(0, 0)

func _ready():
	target_last_tick = x_follow_target.position
	connect("player", pause_menu, "_on_player")
	emit_signal("player", player)
	connect("next_level", win_splashscreen, "_on_next_level")
	emit_signal("next_level", next_level)
