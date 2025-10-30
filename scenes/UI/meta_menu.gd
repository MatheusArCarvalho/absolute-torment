extends Node

signal back_pressed

@export var meta_upgrades:Array[MetaUpgrade] = []

var meta_upgrade_card_scene := preload("res://scenes/UI/meta_upgrade_card.tscn")
var is_from_main_menu:bool = false

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: SoundButton = %BackButton

func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed)
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade:MetaUpgrade in meta_upgrades:
		var meta_upgrade_card_instance:MetaUpgradeCard = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_button_pressed() -> void:
	if is_from_main_menu:
		back_pressed.emit()
	else:
		is_from_main_menu = false
		ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")
