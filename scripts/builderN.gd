
extends Position2D

var global
var list
var listLR
var listS
var listRan
var lastList
var ranLRS
var found = false
export var dir = 1 #1=n 2=e 3=s 4=w



func _ready():
	
	global = get_node("/root/global")
	global.roomCount += 1 #setget-todo
	get_node("visi").hide()
	set_process(true)
	
	
	var markers = get_tree().get_nodes_in_group("marker")
	for i in markers:
		i.hide()
		
	randomize()
	
	if global.roomCount <= 1:
		var ranSide = randi()%2
		if ranSide == 0:
			global.left = true
		else:
			global.left = false
		
	
func _process(delta):
	
	if global.roomCol == true:
		global.roomCol = false
		global.roomCount = 0
		get_tree().reload_current_scene()
	

	randomize()
	
	if found == false:
		#listS = get_node("/root/roomlists").testS
		if global.left == true:
			ranLRS = randi()%2
			if ranLRS == 0:
				list = get_node("/root/roomlists").testL
			else:
				list = get_node("/root/roomlists").testS
			global.left = false
		elif global.left == false:
			ranLRS = randi()%2
			if ranLRS == 0:
				list = get_node("/root/roomlists").testR
			else:
				list = get_node("/root/roomlists").testS
			global.left = true
	
		listRan = list[randi() % list.size()]
		if listRan != global.lastRoom:
			found = true
			global.lastRoom = listRan
			if global.roomCount < 18 && global.roomCol == false:
				var room = load(listRan).instance()
				add_child(room)
				#print(global.left)
			elif global.roomCount >= 18 && global.roomCol == false:
				var end = get_node("/root/roomlists").endRoom
				var room = load(end[randi() % end.size()]).instance()
				add_child(room)
				global.loadingReady = true
			else:
				global.roomCol = false
				global.roomCount = 0
				global.loadingReady = false
				get_tree().reload_current_scene()
		
		


