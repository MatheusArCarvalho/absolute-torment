extends CanvasLayer

signal transitioned_halfway
var skip_emit:bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect


func transition_to_scene(scene_path:String) -> void:
	transition()
	await transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)


func transition() -> void:
	animation_player.play(&"default")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards(&"default")

func emit_transition_halfway() -> void:
	if skip_emit: 
		skip_emit = false
		return
	transitioned_halfway.emit()
