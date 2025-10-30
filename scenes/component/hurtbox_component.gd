extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component:HealthComponent

var floating_text_res := preload("res://scenes/floating_text.tscn")

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component := area as HitboxComponent
	health_component.take_damage(hitbox_component.damage)
	
	var floating_text := floating_text_res.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + Vector2.UP * 16.0
	floating_text.start(str(hitbox_component.damage))
	
	hit.emit()
