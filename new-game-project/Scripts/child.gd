extends RigidBody2D

var isCollected : bool = false
var saved : bool = false
@onready var collectArea = $CollectArea
@onready var dropArea = $"../../DropArea"
@onready var animSprite = $AnimatedSprite2D
@onready var player : PhysicsBody2D = $"../../Player"

var minSpeed = 50
@onready var maxSpeed = player.moveSpeed + 100
var minDistance = 50
var maxDistance = 400
var speed

enum GhostTypes{
	Bear,
	Cat_Cyan,
	Cat_Pink,
	Dog,
	Reptile_Blue,
	Reptile_Green
}
var ghostType : GhostTypes

func _ready() -> void:
	animSprite.play(GhostTypes.keys()[randi_range(0, GhostTypes.size() - 1)])

func _physics_process(delta: float) -> void:
	if isCollected and not collectArea.overlaps_body(player) and not saved:
		var moveDirection := position.direction_to(player.position)
		var toPlayer = position.distance_to(player.position)
		
		if abs(toPlayer) < minDistance:
			speed = minSpeed
		elif abs(toPlayer) >= maxDistance:
			speed = maxSpeed
		else:
			var distanceRatio = (abs(toPlayer) - minDistance) /  (maxDistance - minDistance)
			speed = clamp((distanceRatio * (maxSpeed - minSpeed)) + minSpeed, minSpeed, maxSpeed)
		
		FlipSprite(moveDirection)
		move_and_collide(moveDirection * speed * delta)

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body == player and player.collectedChildren.size() < player.MAX_CHILDREN and not isCollected:
		isCollected = true
		player.collectedChildren.push_back(self)

func Save():
	var saveAnim : Tween = create_tween()
	saveAnim.tween_property(self, "position", dropArea.position, self.position.distance_to(dropArea.position) / maxSpeed)
	saveAnim.tween_callback(self.queue_free)

func FlipSprite(moveDirection : Vector2):
	if moveDirection.x >= 0:
		animSprite.flip_h = false
	else:
		animSprite.flip_h = true
