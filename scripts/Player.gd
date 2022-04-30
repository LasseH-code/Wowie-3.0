extends KinematicBody2D

export var jump_height = 0.0
export var acceleration = 0.0
export var sprint_acceleration = 0.0
export var friction = 0.0
export var air_friction = 0.0
export var max_speed = 0.0
export var max_sprint_speed = 0.0
export var gravity = 0.0
export var terminal_velocity = 0.0

export var jump_height_mul = 1.0
export var acceleration_mul = 1.0
export var sprint_acceleration_mul = 1.0
export var friction_mul = 1.0
export var air_friction_mul = 1.0
export var max_speed_mul = 1.0
export var max_sprint_speed_mul = 1.0
export var gravity_mul = 1.0
export var terminal_velocity_mul = 1.0

var acting_jump_height = 0.0
var acting_acceleration = 0.0
var acting_sprint_acceleration = 0.0
var acting_friction = 0.0
var acting_air_friction = 0.0
var acting_max_speed = 0.0
var acting_max_sprint_speed = 0.0
var acting_gravity = 0.0
var acting_terminal_velocity = 0.0

const UP = Vector2(0, -1)
const coyote_jump = 0.1
onready var coyote_timer = Timer.new()
var velocity = Vector2(0, 0)
var has_friction = false
var do_coyote_jump = false
var dead = false
var paused = false

var right = Input.is_action_pressed("move_right")
var left = Input.is_action_pressed("move_left")
var jump = Input.is_action_just_pressed("jump")
var sprint = Input.is_action_pressed("sprint")

var checkpoint_id = -1
var respawn_coordinates_x
var spawn_x
var y_out_of_screen = Vector2(-100, 700)
export var accept_previous_checkpoints = true
export(NodePath) onready var camera = $"../Camera"
export var win = false

onready var animation_player = $"AnimatedSprite"
const ANIMATION_THRESHOLD = 0.5

var treasure1 = false
var treasure2 = false
#onready var 

onready var jump_sound = $Jump#.stream as AudioStreamOGGVorbis
onready var death_sound = $Death#.stream as AudioStreamOGGVorbis
onready var checkpoint_sound = $Checkpoint

signal camera_reset()
signal submit_treasure(treasure1_data, treasure2_data)

func _on_treasureCollected(id_data):
	if id_data == 0:
		treasure1 = true
	elif id_data == 1:
		treasure2 = true

func _on_win():
	win = true
	emit_signal("submit_treasure", treasure1, treasure2)

func _on_resume():
	paused = false

func _on_kill():
	death_sound.play()
	dead = true

func _on_checkpoint(id_data, x_data):
	#print(str(id_data) + ", " + str(x_data))
	if id_data != checkpoint_id and id_data != -1:
		if id_data < checkpoint_id and !accept_previous_checkpoints:
			pass
		else:
			checkpoint_id = id_data
			respawn_coordinates_x = x_data
			checkpoint_sound.play()

func dead():
	dead = true
	velocity = Vector2(0, 0)
	respawn()

func respawn():
	if checkpoint_id != -1:
		self.position.x = respawn_coordinates_x
		self.position.y = y_out_of_screen.x
		dead = false
	else:
		self.position.x = spawn_x
		self.position.y = y_out_of_screen.x
		emit_signal("camera_reset")
		dead = false
		#get_tree().reload_current_scene()

func teleport_to(to):
	self.position = to

func out_of_bounds_teleport():
	if self.position.y >= y_out_of_screen.y:
		teleport_to(Vector2(self.position.x, y_out_of_screen.x))

func update_acting_vars():
	acting_jump_height = jump_height * jump_height_mul
	acting_acceleration = acceleration * acceleration_mul
	acting_sprint_acceleration = sprint_acceleration * sprint_acceleration_mul
	acting_friction = friction * friction_mul
	acting_air_friction = air_friction * air_friction_mul
	acting_max_speed = max_speed * max_speed_mul
	acting_max_sprint_speed = max_sprint_speed * max_sprint_speed_mul
	acting_gravity = gravity * gravity_mul
	acting_terminal_velocity = terminal_velocity * terminal_velocity_mul

func _ready():
	self.add_child(coyote_timer)
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_jump
	update_acting_vars()
	spawn_x = self.position.x
	connect("camera_reset", camera, "_on_camera_reset")
	connect("submit_treasure", camera, "_on_submit_treasure")
	animation_player.play()
	#jump_sound.set_loop(false)
	#death_sound.set_loop(false)

func input():
	right = Input.is_action_pressed("move_right")
	left = Input.is_action_pressed("move_left")
	
	has_friction = false
	if dead != true and paused != true and win != true:
		if right and sprint:
			velocity.x += acting_sprint_acceleration
			velocity.x = min(velocity.x, acting_max_sprint_speed)
		if left and sprint:
			velocity.x -= acting_sprint_acceleration
			velocity.x = max(velocity.x, -acting_max_sprint_speed)
		if right and !sprint:
			velocity.x += acting_acceleration
			velocity.x = min(velocity.x, acting_max_speed)
		if left and !sprint:
			velocity.x -= acting_acceleration
			velocity.x = max(velocity.x, -acting_max_speed)
		if !left and !right:
			has_friction = true

func applyFriction():
	if is_on_floor():
		do_coyote_jump = true
		if has_friction:
			velocity.x = lerp(velocity.x, 0, acting_friction)
		else:
			velocity.x = lerp(velocity.x, 0, acting_air_friction)
	elif !(coyote_timer.time_left > 0.0) && do_coyote_jump:
		coyote_timer.wait_time = coyote_jump
		#coyote_timer.one_shot = true
		coyote_timer.start()
		do_coyote_jump = false

func performJump():
	if dead != true and paused != true and win != true:
		jump = Input.is_action_just_pressed("jump")
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump_sound.play()
	if jump && is_on_floor() || jump && coyote_timer.time_left > 0.0:
			velocity.y = -acting_jump_height
			coyote_timer.stop()

func _input(_event):
	if Input.is_action_just_released("ui_cancel"):
		paused = !paused

func animation_playback():
	if velocity.x >= ANIMATION_THRESHOLD:
		animation_player.animation = "walk_right"
		animation_player.play()
	elif velocity.x <= -ANIMATION_THRESHOLD:
		animation_player.animation = "walk_left"
		animation_player.play()
	else:
		#animation_player.stop()
		pass

func _physics_process(delta):
	animation_playback()
	out_of_bounds_teleport()
	if dead != true and paused != true:
		velocity.y += acting_gravity * delta
	input()
	applyFriction()
	performJump()
	velocity.normalized()
	if velocity.y < -acting_terminal_velocity:
		velocity.y = acting_terminal_velocity
	if dead != true and paused != true:
		velocity = move_and_slide(velocity, UP)
	elif dead:
		dead()
