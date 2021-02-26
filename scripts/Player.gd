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

var right = Input.is_action_pressed("move_right")
var left = Input.is_action_pressed("move_left")
var jump = Input.is_action_just_pressed("jump")
var sprint = Input.is_action_pressed("sprint")

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

func _physics_process(delta):
	velocity.y += acting_gravity * delta
	input()
	applyFriction()
	performJump()
	velocity.normalized()
	velocity = move_and_slide(velocity, UP)
