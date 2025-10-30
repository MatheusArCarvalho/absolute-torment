class_name ExperienceDropComponent
extends Node

@export_range(0,1) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var exp_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(on_died)
	

func on_died() -> void:
	var adjusted_drop_percent := drop_percent
	var experienc_gain_upgrade_quantity:= MetaProgression.get_current_meta_upgrade_quantity("experience_gain")
	if experienc_gain_upgrade_quantity > 0:
		adjusted_drop_percent += 0.1 * experienc_gain_upgrade_quantity
	
	if randf() > adjusted_drop_percent:
		return
	
	if exp_scene == null:
		return
	
	if not owner is  Node2D:
		return
	
	var spawn_position:Vector2 = owner.global_position
	var exp_instance := exp_scene.instantiate() as Node2D
	var entities_layer := get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(exp_instance)
	exp_instance.global_position = spawn_position
	
	
