extends Node

signal experience_collected(number:int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_hit_damaged

func emit_experience_collected(number:int) -> void:
	experience_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_hit_damaged() -> void:
	player_hit_damaged.emit()
