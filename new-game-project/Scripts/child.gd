extends RigidBody2D

var isCollected : bool = false
var saved : bool = false
@onready var collectArea = $CollectArea
@onready var dropArea = $"../DropArea"

@export var player : PhysicsBody2D
var minSpeed = 50
@onready var maxSpeed = player.moveSpeed + 100
var minDistance = 50
var maxDistance = 400
var speed

func _physics_process(delta: float) -> void:
	if saved:
		move_and_collide(position.direction_to(dropArea.position) * maxSpeed * delta)
	
	elif isCollected and not collectArea.overlaps_body(player):
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
	if body == player and player.childCount < player.MAX_CHILDREN and not isCollected:
		isCollected = true
		player.collectedChildren.push_back(self)
		
