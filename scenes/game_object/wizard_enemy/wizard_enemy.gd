extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D = $Visuals
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var random_stream_player_2d_component: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent

var is_moving:bool = false

func _ready() -> void:
	health_component.died.connect(on_died)
	hurtbox_component.hit.connect(on_hit)

func _physics_process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var move_sign:float = sign(velocity.x)
	if not is_zero_approx(move_sign):
		visuals.scale.x = move_sign

func set_is_moving(moving:bool) -> void:
	is_moving = moving

func on_hit() -> void:
	random_stream_player_2d_component.play_random_audio()

func on_died() -> void:
	queue_free()
