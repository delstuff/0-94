
extends Particles2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_emitting(true)
	get_node("sfxLaser").play("laserHit")
	set_process(true)
	
func _process(delta):
	
	
	if is_emitting() == false:
		print(get_pos())
		queue_free()


