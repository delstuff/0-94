
extends KinematicBody

var time = 0

func _ready():
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	
	
	
	move(Vector3(0,0,-20))
	
	time += 1
	if time > 400:
		queue_free()


