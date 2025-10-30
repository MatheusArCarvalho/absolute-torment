class_name RandomStreamPlayer2DComponent
extends AudioStreamPlayer2D

@export var streams_array:Array[AudioStream]
@export var is_pítch_randomized:bool
@export_range(1.0, 16.0, 0.1) var random_pitch_variation:float = 1.0

func _ready() -> void:
	prepare_randomize_stream_resource()

func prepare_randomize_stream_resource() -> void:
	var randomize_resource:AudioStreamRandomizer = AudioStreamRandomizer.new()
	
	if is_pítch_randomized:
		randomize_resource.random_pitch = random_pitch_variation
	
	
	for i:int in streams_array.size():
		if streams_array.is_empty(): break
		randomize_resource.add_stream(i, streams_array[i])
	
	stream = randomize_resource


func play_random_audio() -> void:
	play()
