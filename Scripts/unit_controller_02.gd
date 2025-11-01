extends Node2D

@export var detect_range: float = 100.0
@export var detect_rate : float = 0.2

var last_detect_time : float
var enemy_list : Array[Unit] = []

@onready var unit : Unit = get_parent()

var selected_unit : Unit




func _process(delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	if time - last_detect_time > detect_rate:
		last_detect_time = time
		_update_enemy_list()
		_detect()
	elif _try_command_unit or _select_unit:
		return
		
func _update_enemy_list():
	enemy_list.clear()
	var raw_list = get_tree().get_nodes_in_group("Unit_AI")
	
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






func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_try_select_unit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_try_command_unit()
	
func _try_select_unit ():
	var unit = _get_selected_unit()
	
	if unit == null or unit.team != Unit.Team.PLAYER:
		_unselect_unit()
	else:
		_select_unit(unit)
	
func _select_unit (unit : Unit):
	_unselect_unit()
	selected_unit = unit
	unit.get_node("PlayerUnit").toggle_selection_visual(true)
	
func _unselect_unit():
	if selected_unit != null:
		selected_unit.get_node("PlayerUnit").toggle_selection_visual(false)
		
	selected_unit = null
	
func _try_command_unit ():
	print("right click at", get_global_mouse_position())
	if selected_unit == null:
		return
		
	var target = _get_selected_unit()
	
	if target != null:
		if target.team != Unit.Team.PLAYER:
			selected_unit.set_attack_target(target)
	else:
		selected_unit.set_move_to_target(get_global_mouse_position())
	
func _get_selected_unit () -> Unit:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	var intersection = space.intersect_point(query, 1)
	
	if intersection.is_empty():
		return null
	if intersection[0].collider is not Unit:
		return null
	return intersection[0].collider
	
	
	
	
	
	
	
