extends CanvasLayer

@onready var continue_button: SoundButton = %ContinueButton
@onready var quit_button: SoundButton = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var victory_stream_player: AudioStreamPlayer = $VictoryStreamPlayer
@onready var defeat_stream_player: AudioStreamPlayer = $DefeatStreamPlayer

func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	var tween:Tween = create_tween()
	tween.tween_property(panel_container, ^"scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, ^"scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "You lost!"
	play_jingle(true)


func play_jingle(defeat:bool = false) -> void:
	if defeat:
		defeat_stream_player.play()
	else:
		victory_stream_player.play()


func on_continue_button_pressed() -> void:
	await continue_button.random_audio_stream_player_component.finished
	ScreenTransition.transition_to_scene("res://scenes/UI/meta_menu.tscn")


func on_quit_button_pressed() -> void:
	
	await quit_button.random_audio_stream_player_component.finished
	get_tree().quit()
	
