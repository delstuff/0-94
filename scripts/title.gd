
extends Spatial

var ran
var time = 0

func _ready():
	
	
	set_process(true)
	
	
func _process(delta):
	
	randomize()
	ran = randi()% 10
	if time < 10:
		time += 1
	else:
		time = 0
	
	var starShooter = get_tree().get_nodes_in_group("starShooter")
	for i in starShooter:
		if ran == time:
			randomize()
			var shoot = randi()% 5
			if shoot == 2:
				var star = preload("res://3d/star.scn").instance()
				star.set_global_transform(i.get_global_transform())
				add_child(star)




func _on_play_pressed():
	get_tree().change_scene("res://scene/start.scn")


func _on_info_pressed():
	get_node("aniCam").play("info",2.0,1.0,false)
	get_node("aniTitle").play("info")
	get_node("hudTitle/info").hide()
	get_node("hudTitle/info").set_disabled(true)
