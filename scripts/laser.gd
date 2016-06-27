
extends RigidBody2D

var particles = preload("res://scene/laserHit.scn")

func _ready():
	
	
	var ani = get_node("aniLaser")
	ani.play("shoot")
	ani.queue("loop")
	
	




func _on_laser_body_enter( body ):
	if body.is_in_group("room"):
		var par = particles.instance()
		par.set_global_pos(get_global_pos())
		get_tree().get_root().add_child(par)
		queue_free()
	if body.is_in_group("egg"):
		var par = particles.instance()
		par.set_global_pos(get_global_pos())
		get_tree().get_root().add_child(par)
		get_parent().get_node("0-94/aniCam").play("lowShake")
		queue_free()
	if body.is_in_group("foe"):
		var par = particles.instance()
		par.set_global_pos(get_global_pos())
		get_tree().get_root().add_child(par)
		get_parent().get_node("0-94/aniCam").play("heavyShake")
		body.energy -= 1
		if body.get_name() == "fishFoe":
			body.get_node("aniFishHit").play("hit")
		queue_free()
