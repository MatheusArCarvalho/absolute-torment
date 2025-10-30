extends Node2D

@export var acceleration:float = 5.0

@onready var area_2d :Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var random_stream_player_component: RandomStreamPlayer2DComponent = $RandomStreamPlayerComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(on_area_enter)

func tween_collect(percent:float, start_position:Vector2) -> void:
	var player:Node2D = get_tree().get_first_node_in_group("player")
	
	if not player: return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start:Vector2 = start_position.direction_to(player.global_position)
	var target_rotation:float = direction_from_start.angle() + deg_to_rad(90.0)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-acceleration * get_physics_process_delta_time()))

func collect() -> void:
	random_stream_player_component.play_random_audio()
	await random_stream_player_component.finished
	GameEvents.emit_experience_collected(1)
	Callable(queue_free).call_deferred()

func disable_collision() -> void:
	collision_shape_2d.disabled = true

func on_area_enter(area:Area2D) -> void:
	Callable(disable_collision).call_deferred()
	
	var tween:Tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, ^"scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)
