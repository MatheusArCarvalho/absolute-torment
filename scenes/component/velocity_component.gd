class_name VelocityComponent
extends Node

@export var max_speed:int = 40
@export var acceleration:float = 5.0

var velocity:Vector2 = Vector2.ZERO

func accelerate_to_player() -> void:
	var owner_node2D:Node2D = owner as Node2D
	if not owner_node2D: return
	
	var player:Node2D = get_tree().get_first_node_in_group("player")
	if not player: return
	
	var direction:Vector2 = owner_node2D.global_position.direction_to(player.global_position)
	accelerate_in_direction(direction)

func accelerate_in_direction(direction:Vector2) -> void:
	var desired_velocity:Vector2 = direction * max_speed
	
	velocity = velocity.lerp(desired_velocity, 1.0 - exp(-acceleration * get_physics_process_delta_time()))

func decelerate() -> void:
	accelerate_in_direction(Vector2.ZERO)
	


func move(character_body:CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
