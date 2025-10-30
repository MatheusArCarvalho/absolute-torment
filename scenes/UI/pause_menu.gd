extends Node

var options_menu_scene:PackedScene = preload("res://scenes/UI/options_menu.tscn")
var is_closing:bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel: PanelContainer = $CanvasLayer/MarginContainer/Panel
@onready var resume_button: SoundButton = %ResumeButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_menu_button: SoundButton = %QuitMenuButton
@onready var quit_game_button: SoundButton = %QuitGameButton

func _ready() -> void:
	get_tree().paused = true
	
	panel.pivot_offset = panel.size/2
	
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_menu_button.pressed.connect(on_quit_menu_button_pressed)
	quit_game_button.pressed.connect(on_quit_game_button_pressed)
	
	open()

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed(&"pause"):
		get_tree().root.set_input_as_handled()
		close()

func open() -> void:
	animation_player.play(&"default")
	var tween:Tween = create_tween()
	tween.tween_property(panel, ^"scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel, ^"scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func close() -> void:
	if is_closing:
		return
	
	is_closing = true
	animation_player.play_backwards(&"default")
	var tween:Tween = create_tween()
	tween.tween_property(panel, ^"scale", Vector2.ONE, 0.0)
	tween.tween_property(panel, ^"scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func on_resume_button_pressed() -> void:
	close()


func on_options_button_pressed() -> void:
	var options_instance:Node = options_menu_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(options_instance:Node) -> void:
	options_instance.queue_free()

func on_quit_menu_button_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")

func on_quit_game_button_pressed() -> void:
	get_tree().quit()
