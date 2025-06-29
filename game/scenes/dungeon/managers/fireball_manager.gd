extends Node
class_name FireballManager

var fireball_scene = preload("res://game/entities/fireball/fireball.tscn")

var attack_cooldown = .5
var last_attack = 0
var direction


func spawn_fireball(position, direction):
	var now = Time.get_unix_time_from_system()
	print(now)
	
	if now - last_attack < attack_cooldown:
		return;
	
	# Create an instance of the fireball scene.
	var fireball = fireball_scene.instantiate()
	
	# Set the fireball's initial position and rotation.
	fireball.position = position
	fireball.rotation = direction.angle()
	
	# Set the fireball's direction.
	fireball.direction = direction
	
	# Add the fireball to the scene tree.
	self.add_child(fireball)
	last_attack = now;
