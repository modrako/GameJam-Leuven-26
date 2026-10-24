extends Camera2D

var targetPosition : Vector2
var moveDirection = Vector2.ZERO
var moveSpeed = 0
@export var moveTime = 0.5


func _process(delta: float) -> void:
	position = position.move_toward(targetPosition, moveSpeed * delta)


func on_room_switch(roomTopLeft : Vector2):
	targetPosition = roomTopLeft
	moveDirection = position.direction_to(roomTopLeft)
	moveSpeed = position.distance_to(roomTopLeft) / moveTime
