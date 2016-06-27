
extends KinematicBody2D

var input_states = preload("res://scripts/input_states.gd")

var LEFT = input_states.new("left")
var RIGHT = input_states.new("right")
var SHOOT = input_states.new("shoot")
var THRUST = input_states.new("thrust")
var REST = input_states.new("restart")
var TEST = input_states.new("test")
var ZOOM = input_states.new("zoom")

var curSpeed = 0.0
var maxSpeed = 14.0
var eccSpeed = 0.02
var turnSpeed = 0.4
var rotSpeed = 0.1
var eccRot = 0.08
var curRot = 0.0

var energy = 10 #setget setEnergy

var aniRot = 0.0
var thrustSfx = false


var dir = Vector2()
var shooterPos = Vector2()
var vel = Vector2()
var velGrav = Vector2()

var crash = false
var crashDir = Vector2()
var crashT = 0

var laser = preload("res://scene/laser.scn")
var roomHit = preload("res://scene/roomHit.scn")

var alive = true
var blastReady = true
var returnReady = false

func _ready():
	
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	#debug
	if REST.check() == 1:
		get_node("/root/global").loadingReady = false
		get_tree().reload_current_scene()
		get_node("/root/global").roomCount = 0
		
	#loadingScreen:
	if get_node("/root/global").loadingReady == false:
		get_node("cam/whity").show()
		get_node("coli0-94").set_trigger(true)
	else:
		get_node("cam/whity").hide()
		get_node("coli0-94").set_trigger(false)
		
		
	#energy
	if energy > 10:
		energy = 10
	if energy < 2:
		energy = 2
	
	if alive == true:
		#rotation
		if LEFT.check() == 2:
			curRot = lerp(curRot, rotSpeed, eccRot)
			rotate(curRot)
		
		elif RIGHT.check() == 2:
			curRot = lerp(curRot, rotSpeed, eccRot)
			rotate(-curRot)
		else:
			curRot = lerp(curRot, 0.0, eccRot)
		#thrust
		
		if THRUST.check() == 2:
			curSpeed = lerp(curSpeed, maxSpeed, eccSpeed)
			shooterPos = get_node("shooter").get_global_pos()
			dir = (shooterPos-get_global_pos()).normalized()
			get_node("thrusterSprite").show()
			if thrustSfx == false:
				thrustSfx = true
				get_node("sfxThrust").play("thrust")
			if RIGHT.check() == 2 or LEFT.check() == 2:
				curSpeed = lerp(curSpeed, turnSpeed, eccSpeed)
				
			
		
		
		elif THRUST.check() != 2:
			curSpeed = curSpeed/1.02
			get_node("thrusterSprite").hide()
			thrustSfx = false
			get_node("sfxThrust").stop_all()
		
		vel = dir*curSpeed
		move(vel)
	
	
		#shoot
		if SHOOT.check() == 1:
			var laserInst = laser.instance()
			laserInst.set_pos(get_node("shooter").get_global_pos())
			laserInst.set_rot(get_rot())
			laserInst.set_linear_velocity(Vector2((laserInst.get_global_pos()-get_global_pos()).normalized()*16/delta))
			get_parent().add_child(laserInst)
			get_node("aniShip").play("shoot")
			get_node("sfxShip").play("laser")
		
		
	#animation
		var sprite = get_node("shipSprite2")
		aniRot = get_rot()
		if aniRot < -0.3:
			aniRot *= -1
		if aniRot > -0.3 && aniRot < 0.3 or aniRot > 2.7:
			sprite.set_frame(4)
		elif aniRot > 0.3 && aniRot < 0.6 or aniRot > 2.4 && aniRot < 2.7:
			sprite.set_frame(3)
		elif aniRot > 0.6 && aniRot < 0.9 or aniRot > 2.1 && aniRot < 2.4:
			sprite.set_frame(2)
		elif aniRot > 0.9 && aniRot < 1.2 or aniRot > 1.8 && aniRot < 2.1:
			sprite.set_frame(1)
		elif aniRot > 1.2 && aniRot < 1.8:
			sprite.set_frame(0)
		if get_rot() < -0.3:
			sprite.set_scale(Vector2(-1,1))
		elif get_rot() > -0.3:
			sprite.set_scale(Vector2(1,1))
	
	
		#crash
		if crash == true:
			crashT += 1
			move(crashDir*3)
			if crashT > 10:
				crash = false
				crashT = 0
	
		#collisions
		if is_colliding():
			var col = get_collider()
			if col.is_in_group("room"):
				crash = true
				crashDir = get_collision_normal()
				get_node("aniShip").play("hit")
				get_node("sfxShip").play("laserHit")
				#get_node("aniWhity").play("flash")
				energy -= 2
				curSpeed = 0.0
				var aniE = get_node("/root/start/hud/hud/aniE")
				aniE.set_current_animation("energy")
				aniE.seek(energy, true)
				var hit = roomHit.instance()
				hit.set_global_pos(get_collision_pos())
				get_parent().add_child(hit)
			if col.is_in_group("energy"):
				energy += 3
				col.get_node("aniEPUP").play("collect")
				col.get_node("colEPUP").queue_free()
				col.get_node("coin").queue_free()
				#col.queue_free()
				var aniE = get_node("/root/start/hud/hud/aniE")
				aniE.set_current_animation("energy")
				aniE.seek(energy, true)
			if col.is_in_group("foe"):
				crash = true
				crashDir = get_collision_normal()
				energy -= 4
				curSpeed = 0.0
				get_node("sfxShip").play("laserHit")
				var aniE = get_node("/root/start/hud/hud/aniE")
				aniE.set_current_animation("energy")
				aniE.seek(energy, true)
				
				
		if TEST.check() == 1:
			get_node("aniCam").play("heavyShake")
			randomize()
			print(rand_range(0,3))
			
		if ZOOM.check() == 1:
			get_node("aniCam").play("zoomOut")
				
		#death
		if energy <= 1:
			alive = false
			
	if alive == false:
		get_node("shipSprite2").hide()
		get_node("thrusterSprite").hide()
		
		if has_node("blast") == true:
			get_node("blast").show()
		if blastReady == true:
			get_node("blast/aniBlast").play("blast")
			get_node("sfxShip").play("blast")
			get_node("sfxThrust").stop_all()
			get_node("aniCam").play("heavyShake")
			get_node("aniCam").queue("zoomOut")
			get_tree().get_root().get_node("start/hud/hud/aniDeath").play("died")
			blastReady = false
		if get_node("aniCam").get_pos() > 5:
			returnReady = true

		if blastReady == false:
			if SHOOT.check() == 1 and returnReady == true:
				get_tree().change_scene("res://scene/title.scn")
				get_node("/root/global").loadingReady = false
				get_node("/root/global").roomCount = 0
				if get_tree().has_group("foe"):
					var foes = get_tree().get_nodes_in_group("foe")
					for i in foes:
						i.queue_free()
			
			
			
	#print(get_node("/root/start/hud/hud/aniE").get_name())


#func setEnergy(value):
##	energy = value
#	var aniE = get_node("/root/start/hud/hud/aniE")
#	aniE.set_current_animation("energy")
#	aniE.seek(energy, true)

	


