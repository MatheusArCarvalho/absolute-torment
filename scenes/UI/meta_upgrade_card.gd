class_name MetaUpgradeCard
extends PanelContainer

var upgrade:MetaUpgrade

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: SoundButton = %PurchaseButton
@onready var experience_label: Label = %ExperienceLabel
@onready var count_label: Label = %CountLabel

func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_button_pressed)


func update_progress() -> void:
	var current_quantity:int = MetaProgression.get_current_meta_upgrade_quantity(upgrade.id)
	var is_maxed_out:bool = current_quantity >= upgrade.max_quantity
	var currency:int = MetaProgression.get_current_currency()
	var percent:float = float(currency) / float(upgrade.experience_cost)
	percent = min(percent, 1.0)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1.0 || is_maxed_out
	if is_maxed_out:
		purchase_button.text = "Sold Out"
	experience_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" %current_quantity


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func on_purchase_button_pressed() -> void:
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data.meta_upgrade_currency = max(\
	MetaProgression.save_data.meta_upgrade_currency - upgrade.experience_cost, 0) 
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play(&"selected")
