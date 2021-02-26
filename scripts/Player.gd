extends KinematicBody2D

export var jump_height = 0.0
export var acceleration = 0.0
export var sprint_acceleration = 0.0
export var friction = 0.0
export var air_friction = 0.0
export var max_speed = 0.0
export var max_sprint_speed = 0.0
export var gravity = 0.0

export var jump_height_mul = 1.0
export var acceleration_mul = 1.0
export var sprint_acceleration_mul = 1.0
export var friction_mul = 1.0
export var air_friction_mul = 1.0
export var max_speed_mul = 1.0
export var max_sprint_speed_mul = 1.0
export var gravity_mul = 1.0

var acting_jump_height = 0.0
var acting_acceleration = 0.0
var acting_sprint_acceleration = 0.0
var acting_friction = 0.0
var acting_air_friction = 0.0
var acting_max_speed = 0.0
var acting_max_sprint_speed = 0.0
var acting_gravity = 0.0

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
var y_out_of_screen = Vector2(-100, 700)
export var accept_previous_checkpoints = true

func _on_resume():
	paused = false

func _on_kill():
	dead = true

func _on_checkpoint(id_data, x_data):
	#print(str(id_data) + ", " + str(x_data))
	if id_data != checkpoint_id and id_data != -1:
		if id_data < checkpoint_id and !accept_previous_checkpoints:
			pass
		else:
			checkpoint_id = id_data
			respawn_coordinates_x = x_data

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
		get_tree().reload_current_scene()

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

func _ready():
	self.add_child(coyote_timer)
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_jump
	update_acting_vars()

func input():
	right = Input.is_action_pressed("move_right")
	left = Input.is_action_pressed("move_left")
	
	has_friction = false
	if dead != true and paused != true:
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
	jump = Input.is_action_just_pressed("jump")
	if jump && is_on_floor() || jump && coyote_timer.time_left > 0.0:
			velocity.y = -acting_jump_height
			coyote_timer.stop()

func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		paused = !paused

func _physics_process(delta):
	out_of_bounds_teleport()
	velocity.y += acting_gravity * delta
	input()
	applyFriction()
	performJump()
	velocity.normalized()
	if dead != true and paused != true:
		velocity = move_and_slide(velocity, UP)
	elif dead:
		dead()
