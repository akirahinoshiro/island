extends KinematicBody

const MOVE_SPEED = 1.0
const JUMP_FORCE = 2.0
const GRAVITY = 0.098
const MAX_FALL_SPEED = 3

const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0

onready var cam = $CamBase
onready var anim = $chickenV2/AnimationPlayer
onready var label = $Control/HBoxContainer/Label
var velocity = 0

var y_velo = 0
var dead = false

func _ready():
	label.visible = true
#	anim.get_animation("Idle1").set_loop(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS

func _physics_process(_delta):
	if !dead:
		var fps = Engine.get_frames_per_second()
		label.set_text(str(fps))
		var move_vec = Vector3()
		if Input.is_action_pressed("move_forwards"):
			move_vec.z -= 1
			$chickenV2.set_rotation_degrees(Vector3(0,180,0))
		if Input.is_action_pressed("move_backwards"):
			move_vec.z += 1
			$chickenV2.set_rotation_degrees(Vector3(0,0,0))
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1			
			$chickenV2.set_rotation_degrees(Vector3(0,90,0))
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1			
			$chickenV2.set_rotation_degrees(Vector3(0,270,0))
		move_vec = move_vec.normalized()
		move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
		move_vec *= MOVE_SPEED
		move_vec.y = y_velo
		#velocity = move_and_slide(move_vec, Vector3(0, 1, 0))
		velocity = move_and_slide(move_vec, Vector3.UP, true, 3, 0.6, true)
	
		var grounded = is_on_floor()
		y_velo -= GRAVITY
		var just_jumped = false
		if grounded and Input.is_action_just_pressed("jump"):
			just_jumped = true
			y_velo = JUMP_FORCE
		if grounded and y_velo <= 0:
			y_velo = -0.1
		if y_velo < -MAX_FALL_SPEED:
			y_velo = -MAX_FALL_SPEED
	
		if just_jumped:
			play_anim("BeginPecking", -1, 1)
		elif grounded:
			if move_vec.x == 0 and move_vec.z == 0:
				play_anim("Idle1", -1, 1)
			else:
				play_anim("Walk", -1, 20.0)
		if (global_transform.origin.y < -10 and !dead):
			play_anim("Dying", -1, 1)
			dead = true
			label.visible = true
			label.set_text("YOU ARE DEAD!")

func play_anim(name, blend, custom_speed):
	if anim.current_animation == name:
		return
	anim.play(name, blend, custom_speed)
