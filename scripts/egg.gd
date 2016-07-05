
extends RigidBody2D

export var type = "energy"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func hit():
	var cracks = preload("res://scene/stuff/eggCracked.scn").instance()
	cracks.set_global_pos(get_global_pos())
	cracks.set_rot(get_rot())
	get_tree().get_root().add_child(cracks)
	var ePUP = preload("res://scene/stuff/energyPUP.scn").instance()
	ePUP.set_global_pos(get_global_pos())
	get_tree().get_root().add_child(ePUP)
	queue_free()

func _on_egg_body_enter( body ):
	if body.get_name() == "laser":
		hit()
