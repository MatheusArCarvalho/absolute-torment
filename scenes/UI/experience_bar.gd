extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar := $MarginContainer/ProgressBar

func _ready() -> void:
	if experience_manager == null:
		return
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)

func on_experience_updated(current_experience:int, target_experience:int) -> void:
	var percent := float(current_experience) / float(target_experience)
	progress_bar.value = percent
