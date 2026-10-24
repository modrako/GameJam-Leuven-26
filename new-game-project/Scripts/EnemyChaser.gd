extends Enemy

@export var enemyVelocity:float = 10
@export var target: PhysicsBody2D


func _process(delta: float) -> void:
	move_and_collide(global_position.direction_to(target.global_position) * enemyVelocity * delta)
	
func _on_on_body_entered(body: Node2D) -> void:
	dealDamage()
	
func dealDamage() -> void:
	#add check for player and damage function call
	print("die")
