
extends Position2D

var list
var ran

func _ready():
	
	
	var pRot = get_parent().get_parent().get_rot()
	if pRot != 0:
		pass
	#print(get_global_transform())
	
	
	
	randomize()
	
	list = get_node("/root/roomlists").foes
	var foe = load(list[randi() % list.size()]).instance()
	foe.set_global_pos(get_global_pos())
	var roomCount = get_node("/root/global").roomCount
	if roomCount < 5:
		ran = randi()%4
		if ran == 0:
			get_tree().get_root().add_child(foe)
	elif roomCount > 5 && roomCount < 10:
		ran = randi()%3
		if ran == 0:
			get_tree().get_root().add_child(foe)
	elif roomCount > 10:
		ran = randi()%2
		if ran == 0:
			get_tree().get_root().add_child(foe)
	
	
	
	
	
	#print(get_rot())


