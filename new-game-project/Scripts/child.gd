extends RigidBody2D

var isCollected : bool = false
@onready var collectArea = $CollectArea

@export var player : PhysicsBody2D
var minSpeed = 100
@onready var maxSpeed = player.moveSpeed + 100
var minDistance = 50
var maxDistance = 400
var speed

func _process(delta: float) -> void:
	if isCollected and not collectArea.overlaps_body(player):
		var moveDirection := position.direction_to(player.position)
		var toPlayer = position.distance_to(player.position)
		
		if abs(toPlayer) < minDistance:
			speed = minSpeed
		elif abs(toPlayer) >= maxDistance:
			speed = maxSpeed
		else:
			var distanceRatio = (abs(toPlayer) - minDistance) /  (maxDistance - minDistance)
			speed = clamp((distanceRatio * (maxSpeed - minSpeed)) + minSpeed, minSpeed, maxSpeed)
		
		move_and_collide(moveDirection * speed * delta)

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body == player:
		isCollected = true
