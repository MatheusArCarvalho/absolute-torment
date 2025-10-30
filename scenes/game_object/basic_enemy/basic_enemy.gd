extends CharacterBody2D

@onready var health_component:HealthComponent = $HealthComponent
@onready var experience_drop_component: ExperienceDropComponent = $ExperienceDropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D = $Visuals
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var random_stream_player_2d_component: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent




func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)
	health_component.died.connect(on_died)


func _physics_process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign:float = sign(velocity.x)
	if not is_zero_approx(move_sign):
		visuals.scale.x = move_sign

func on_hit() -> void:
	random_stream_player_2d_component.play_random_audio()


func on_died() -> void:
	Callable(queue_free).call_deferred()
