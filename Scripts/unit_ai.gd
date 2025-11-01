extends Node2D

#detection range
@export var detect_range : float = 100.0

#Improves performance by decreasing process checks
@export var detect_rate : float = 0.2

var last_detect_time : float
var enemy_list : Array[Unit] = []

@onready var unit : Unit = get_parent()


func _process(delta):
	var time = Time.get_unix_time_from_system()
	
	if time - last_detect_time > detect_rate:
		last_detect_time = time
		_update_enemy_list()
		_detect()
		
func _update_enemy_list():
	#Makes sure the enemy is in the list unit to start attacking
	enemy_list.clear()
	#gets rid of null values in unit list
	var raw_list = get_tree().get_nodes_in_group("Unit_Player")
	
	for node in raw_list:
		if node is not Unit:
			continue
			
		enemy_list.append(node)
	
func _detect():
	var closest_enemy = null
	var closest_dist = detect_range
		
	for enemy in enemy_list:
		var dist = unit.global_position.distance_to(enemy.global_position)
			
		if dist < closest_dist:
			closest_enemy = enemy
			closest_dist = dist
		
	if closest_enemy != null:
		unit.set_attack_target(closest_enemy)
	
