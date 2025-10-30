extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager
@onready var label := $MarginContainer/Label
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed:float = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds:float) -> String: 
	var minutes:float = floor(seconds/60.0)
	var remaining_seconds:float = seconds - (minutes * 60.0)
	return str("%02d" %[minutes]) + ":" + ("%02d" %[floor(remaining_seconds)])
