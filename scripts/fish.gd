
extends KinematicBody2D

var crash = false
var crashT = 0
var crashDir = Vector2()
var ship
var attackReady = false
var energy = 2
var died = false

func _ready():
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	
	stroll()
	
	ship = get_tree().get_root().get_node("start/stRoom/startPos/0-94")
	
	look_at(ship.get_global_pos())
	
	if get_global_pos().distance_to(ship.get_global_pos()) < 300:
		attackReady = true
	if attackReady == true:
		attack()
		
	if crash == true:
		crashT += 1
		move(crashDir*3)
		if crashT > 10:
			crash = false
			crashT = 0
			
			
	if energy <= 0 && died == false:
		died = true
		var cracks = preload("res://scene/stuff/eggCracked.scn").instance() #test
		cracks.set_global_pos(get_global_pos())
		get_tree().get_root().add_child(cracks)
		randomize()
		var getGoodie = randi()%3
		if getGoodie == 2:
			var ePUP = preload("res://scene/stuff/energyPUP.scn").instance()
			ePUP.set_global_pos(get_global_pos())
			get_tree().get_root().add_child(ePUP)
		queue_free()
	
	if is_colliding():
		var col = get_collider()
		if col.is_in_group("room"):
			crash = true
			crashDir = get_collision_normal()
			
			
			
func stroll():
	pass
	
func attack():
	
	move((ship.get_global_pos() - get_global_pos()).normalized() * 1.6)
	





