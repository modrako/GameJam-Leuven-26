@abstract 
class_name Enemy
extends CharacterBody2D

@export var target : PhysicsBody2D

signal Hit()

func _ready() -> void:
	assert(target.has_method("on_enemy_hit"))
	assert(target.is_node_ready())
	Hit.connect(target.on_enemy_hit)

func dealDamage() -> void:
	Hit.emit()
