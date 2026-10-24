extends Enemy

@export var speed:float = 10
@export var target:Node2D


func dealDamage() -> void:
	print("die")
	
func _process(delta: float) -> void:
	position = position.move_toward(target.position,speed * delta)

func _on_on_body_entered(body: Node2D) -> void:
	if body.name.contains("text"):
		dealDamage();
