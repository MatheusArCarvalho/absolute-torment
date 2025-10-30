extends Node2D

@export var health_component:HealthComponent
@export var sprite:Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var random_stream_player_2d_component: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent


func _ready() -> void:
	health_component.died.connect(on_died)
	if sprite:
		gpu_particles_2d.texture = sprite.texture

func on_died() -> void:
	if owner == null or not owner is Node2D:
		return
	var spawn_position:Vector2 = owner.global_position
	var entities:Node2D = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	animation_player.play(&"default")
	random_stream_player_2d_component.play_random_audio()
