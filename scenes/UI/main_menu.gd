extends Node

var options_scene:PackedScene = preload("res://scenes/UI/options_menu.tscn")
var meta_menu_scene:PackedScene = preload("res://scenes/UI/meta_menu.tscn")

@onready var play_button: SoundButton = %PlayButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton
@onready var meta_upgrades_button: SoundButton = %MetaUpgradesButton

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	meta_upgrades_button.pressed.connect(on_meta_upgrades_button_pressed)

func on_play_button_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")

func on_meta_upgrades_button_pressed() -> void:
	var meta_menu_instance := meta_menu_scene.instantiate()
	meta_menu_instance.is_from_main_menu = true
	add_child(meta_menu_instance)
	meta_menu_instance.back_pressed.connect(on_options_closed.bind(meta_menu_instance))

func on_options_button_pressed() -> void:
	var options_instance := options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))

func on_meta_menu_closed(meta_menu:Node) -> void:
	meta_menu.queue_free()

func on_options_closed(options_instance:Node) -> void:
	options_instance.queue_free()


func on_quit_button_pressed() -> void:
	get_tree().quit()
