extends Node

@export var experience_manager:ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades := {}
var upgrade_pool:WeightedTable = WeightedTable.new()

const UPGRADE_AXE := preload("res://resources/upgrades/axe_upgrade.tres")
const UPGRADE_AXE_DAMAGE := preload("res://resources/upgrades/axe_damage.tres")
const UPGRADE_MOVE_SPEED := preload("res://resources/upgrades/move_speed.tres")
const UPGRADE_SWORD_DAMAGE := preload("res://resources/upgrades/sword_damage.tres")
const UPGRADE_SWORD_RADIUS := preload("res://resources/upgrades/sword_radius.tres")
const UPGRADE_SWORD_RATE := preload("res://resources/upgrades/sword_rate.tres")
const PLAYER_SPEED = preload("res://resources/upgrades/player_speed.tres")

func _ready() -> void:
	upgrade_pool.add_item(UPGRADE_AXE, 10)
	upgrade_pool.add_item(UPGRADE_SWORD_RATE, 10)
	upgrade_pool.add_item(UPGRADE_SWORD_DAMAGE, 10)
	upgrade_pool.add_item(UPGRADE_SWORD_RADIUS, 10)
	upgrade_pool.add_item(UPGRADE_MOVE_SPEED, 10)
	upgrade_pool.add_item(PLAYER_SPEED, 10)
	
	experience_manager.leveled_up.connect(on_leveled_up)

func update_upgrade_tool(chosen_upgrade: AbilityUpgrade) -> void:
	if chosen_upgrade.id == UPGRADE_AXE.id:  
		upgrade_pool.add_item(UPGRADE_AXE_DAMAGE, 10)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	#print(current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity:int = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_tool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func pick_upgrades() -> Array:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var upgrade_chosen := upgrade_pool.pick_item_at_random_weight(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(upgrade_chosen)
	
	return chosen_upgrades

func on_leveled_up(current_level:int) -> void:
	var upgrade_screen_instance := upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrade := pick_upgrades()
	upgrade_screen_instance.set_abitity_upgrades(chosen_upgrade as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
