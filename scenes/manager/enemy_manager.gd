extends Node2D

const SPAWN_RADIUS = 380

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export_flags_2d_physics var collision_mask:int

var base_spawn_time:float = 0.0
var enemy_weighted_table:WeightedTable = WeightedTable.new()

@onready var timer := $Timer

func _ready() -> void:
	enemy_weighted_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position() -> Vector2:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset := random_direction * 20.0
		
		var query_paramaters:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(\
		player.global_position, spawn_position + additional_check_offset, collision_mask)
		var result := get_world_2d().direct_space_state.intersect_ray(query_paramaters)
		
		if result.is_empty():
			break
		else:
			spawn_position = result.position
			print(result.position)
			random_direction = random_direction.rotated(deg_to_rad(90.0))
	
	return spawn_position



func on_timer_timeout() -> void:
	timer.start()
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_packed_scene:PackedScene = enemy_weighted_table.pick_item_at_random_weight() as PackedScene
	var enemy_instance:Node2D = enemy_packed_scene.instantiate() as Node2D
	var entities_layer:Node2D = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	

func on_arena_difficulty_increased(arena_difficulty:int) -> void:
	var time_off := (0.1/10)*arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	#print(timer.wait_time)
	
	if arena_difficulty == 6:
		enemy_weighted_table.add_item(wizard_enemy_scene, 20)
