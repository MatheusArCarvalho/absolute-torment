class_name Player
extends CharacterBody2D

var base_speed:float = 0

var number_colliding_bodies := 0
var start_scale := scale

@onready var collision_area:Area2D = $CollisionArea2D
@onready var health_component:HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var random_stream_player_component: RandomStreamPlayer2DComponent = $RandomStreamPlayerComponent


func _ready() -> void:
	base_speed = velocity_component.max_speed
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_bar()

func _physics_process(delta: float) -> void:
	var direction:Vector2 = get_movement_vector()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if direction.x != 0 || direction.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign:float = sign(direction.x)
	if not is_zero_approx(move_sign):
		visuals.scale.x = move_sign * start_scale.x

func get_movement_vector() -> Vector2:
	var vector:Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	
	return vector

func check_deal_damage() -> void:
	if number_colliding_bodies <= 0 || not damage_interval_timer.is_stopped():
		return
	
	health_component.take_damage(1)
	damage_interval_timer.start()
	#print(health_component.current_health)

func update_health_bar() -> void:
	var value:float = health_component.get_health_percent()
	health_bar.value = value

func on_body_entered(body:Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(body:Node2D) -> void:
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()

func on_health_changed() -> void:
	GameEvents.emit_player_hit_damaged()
	update_health_bar()
	random_stream_player_component.play_random_audio()

func on_ability_upgrade_added(ability_upgrade:AbilityUpgrade, current_upgrades:Dictionary) -> void:
	if ability_upgrade is Ability:
		var ability:Ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades.player_speed.quantity * .1)
	
