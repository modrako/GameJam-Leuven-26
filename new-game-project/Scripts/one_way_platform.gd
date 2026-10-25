extends StaticBody2D

@onready var collider = $CollisionShape2D
@onready var disableTimer : Timer = $Disable


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down") and not collider.disabled:
		collider.disabled = true
		disableTimer.start(1)


func _on_disable_timeout() -> void:
	collider.disabled = false
