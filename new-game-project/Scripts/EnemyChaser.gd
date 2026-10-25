extends Enemy

@export var enemyVelocity:float = 40

func _physics_process(delta: float) -> void:
	move_and_collide(global_position.direction_to(target.global_position) * enemyVelocity * delta)
	
func _on_on_body_entered(_body: Node2D) -> void:
	if _body != target:
		return
	super.dealDamage(position)
	
