class_name ExperienceManager
extends Node

signal experience_updated(current_experience:int, target_experience:int)
signal leveled_up(new_level:int)

const TARGET_EXPERIENCE_GROWTH:int = 5

var current_experience:int = 0
var current_level:int = 1
var target_experience:int = 1

func _ready() -> void:
	GameEvents.experience_collected.connect(on_experience_collected)

func increment_experience(number:int) -> void:
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience, target_experience)
	if current_experience == target_experience:
		level_up()

func level_up() -> void:
	current_level += 1
	target_experience += TARGET_EXPERIENCE_GROWTH
	current_experience = 0
	experience_updated.emit(current_experience, target_experience)
	leveled_up.emit(current_level)

func on_experience_collected(number:float) -> void:
	increment_experience(number)
