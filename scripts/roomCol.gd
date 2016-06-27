
extends Area2D

var global

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	global = get_node("/root/global")




func _on_roomCol_area_enter( area ):
	global.roomCol = true
	print("roomcolA")


func _on_roomCol_body_enter( body ):
	global.roomCol = true
	print("roomcolB")