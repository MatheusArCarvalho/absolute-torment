extends Node

@export var max_range := 150


@export var damage:int = 10
var base_damage:int = 10
var additional_damage_percent:float = 1.0

var base_wait_time := 1.5

@export var sword_ability: PackedScene

@onready var timer:Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies := get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy:Node2D) -> bool: 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	if enemies.is_empty():
		return
	
	enemies.sort_custom(func(a:Node2D, b:Node2D) -> bool:
		var a_distance := a.global_position.distance_squared_to(player.global_position)
		var b_distance := b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	var sword_instance := sword_ability.instantiate() as SwordAbility
	var foreground_layer := get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = floori(base_damage * additional_damage_percent)
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	var enemy_direction:Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary) -> void:
	match upgrade.id:
		"sword_rate":
			var percent_reduction:float = current_upgrades["sword_rate"]["quantity"] * 0.1
			timer.wait_time = base_wait_time * (1.0 - percent_reduction)
			timer.start()
		"sword_damage":
			additional_damage_percent = 1 + (current_upgrades.sword_damage.quantity * 0.15)
		_:
			return
