extends Node

signal back_pressed


@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_button: SoundButton = %WindowButton
@onready var master_slider: HSlider = %MasterSlider
@onready var back_button: SoundButton = %BackButton


func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	master_slider.value_changed.connect(on_audio_slider_changed.bind("Master"))
	
	update_display()


func update_display() -> void:
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	master_slider.value = get_bus_volume_percent("Master")
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name:String) -> float:
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_linear(bus_index)


func set_bus_volume_percent(bus_name:String, percent:float) -> void:
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(bus_index, percent)
	


func on_window_button_pressed() -> void:
	var mode:DisplayServer.WindowMode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func on_audio_slider_changed(value:float, bus_name:String) -> void:
	set_bus_volume_percent(bus_name, value)


func on_back_button_pressed() -> void:
	back_pressed.emit()
