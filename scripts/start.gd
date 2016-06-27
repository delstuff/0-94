
extends Node2D


var start
var list
var startUp = false
#var rand = []
var isPlaying = false


func _ready():
	
	#cleanup
	if get_tree().has_group("foe"):
		var foes = get_tree().get_nodes_in_group("foe")
		for i in foes:
			i.queue_free()
			
	
	
	#set_process(true)
	randomize()
	list = get_node("/root/roomlists").startRoom
	start = load(list[randi() % list.size()]).instance()
	add_child(start)
	get_node("/root/global").roomCol = false
	
	set_process(true)
	
func _process(delta):
	
	if get_node("/root/global").loadingReady == true && isPlaying == false:
		isPlaying = true
		get_node("gameSong").play()
	

	
	
	



