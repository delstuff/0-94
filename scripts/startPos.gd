
extends Position2D

var ship = preload("res://scene/0-94.scn")

func _ready():
	add_child(ship.instance())


