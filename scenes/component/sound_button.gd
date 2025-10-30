class_name SoundButton
extends Button

@onready var random_audio_stream_player_component: AudioStreamPlayer = $RandomAudioStreamPlayerComponent


func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed() -> void:
	random_audio_stream_player_component.play()
