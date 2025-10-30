extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: int = 10
var current_health:int = 0

func _ready() -> void:
	current_health = max_health

func take_damage(damage:int) -> void:
	current_health = max(current_health - damage, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()

func get_health_percent() -> float:
	if current_health <= 0:
		return 0
	
	var value:float = float(current_health)/float(max_health)
	return min(value, 1.0)

func check_death() -> void:
	if current_health == 0:
		died.emit()
