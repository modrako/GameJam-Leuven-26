extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var enemyVelocity:float = 40

func _process(delta: float) -> void:
	if global_position.direction_to(target.position).x >0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
func _physics_process(delta: float) -> void:
	move_and_collide(global_position.direction_to(target.global_position) * enemyVelocity * delta)
	
func _on_on_body_entered(_body: Node2D) -> void:
	if _body != target:
		return
	super.dealDamage(position)
	
