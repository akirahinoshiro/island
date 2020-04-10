extends Spatial

onready var node = get_node("DirectionalLight")
onready var player = get_node("player")
onready var light = $DirectionalLight
onready var sun = $sun

var target : Vector3
var frame = 0
var r = 50
var alpha = 0

func _ready():
	#target = Vector3(rand_range(-1,1), rand_range(-1,1), rand_range(-1,1))
	#yield(get_tree().create_timer(0.5),"timeout")
	frame = 0

func _process(_delta):
	if frame > 10:
		node._setDirection(player)
		sun.translation = target
		alpha += 1
		target = Vector3(0, r*cos(alpha*PI/180), r*sin(alpha*PI/180))
		light.translation = target
		frame = 0
		#print(cos(alpha*PI/180))
		if (cos(alpha*PI/180) > .45):
			#light.light_energy = 1
			light.light_color = Color(.5,.5,.5,1)
			var material = sun.mesh.surface_get_material(0)
			material.albedo_color = Color(1,1,1,1)
		elif (cos(alpha*PI/180) < -.15):
			#light.light_color = Color(0,0,0,0)
			light.light_energy = 0
		else:
			light.light_energy = (cos(alpha*PI/180) + .15) * 10
			light.light_color = Color(1 - (cos(alpha*PI/180) + .15)/1.2,.5,.5,1)
			var material = sun.mesh.surface_get_material(0)
			material.albedo_color = Color(1 - (cos(alpha*PI/180) + .15)/1.2,.5,.5,1)
			#light.light_color = 0
			#light.light_color = 0
			#print ((r*cos(alpha*PI/180)+15)/30)
	frame = frame+1
