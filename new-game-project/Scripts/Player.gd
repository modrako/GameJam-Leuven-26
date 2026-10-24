extends CharacterBody2D

#region movementVariables
@export var moveSpeed := 300

@export var jumpHeight : float = 200
@export var timeToFullJump : float = 0.2
@export var timeToPeak : float = 0.6
@export var timeToDescend : float = 0.4
@onready var jumpHold : Timer = $Timer

var jumpImpulse : float = -2 * jumpHeight / timeToPeak
var jumpGravity : float = CalculateGravity(timeToPeak)
var fallGravity : float = CalculateGravity(timeToDescend)
var shortJumpScale := 3
var canJump = false
#endregion
#TODO: Coyote Time
#TODO: Jump buffer
#TODO: Damage feedback
#TODO: Death
#TODO: I-frames

@export var health := 5
@onready var spriteAnim = $AnimatedSprite2D

const MAX_CHILDREN := 3
var collectedChildren = []

func _physics_process(delta: float) -> void:
	velocity.y += GetGravity() * delta
	
	Move()
	
	if is_on_floor():
		canJump = true

	Jump();
	if not is_on_floor():
		if velocity.y <= 0:
			spriteAnim.play("Rise")
		else:
			spriteAnim.play("Fall")
	
	
	
	move_and_slide()
	

func Move() -> void:
	if Input.is_action_pressed("move_left"):
		spriteAnim.flip_h = true
		spriteAnim.play("Walk")
		velocity.x = -moveSpeed
	elif Input.is_action_pressed("move_right"):
		spriteAnim.flip_h = false
		spriteAnim.play("Walk")
		velocity.x = moveSpeed
	else:
		velocity.x = 0
		spriteAnim.play("Idle")

func Jump() -> void:
	if Input.is_action_just_pressed("move_jump"):
		if canJump:
			canJump = false
			velocity.y = jumpImpulse
			jumpHold.start()

func CalculateGravity(time : float) -> float:
	return 2 * jumpHeight / pow(time, 2.0)

func GetGravity():
	if velocity.y <= 0 and Input.is_action_pressed("move_jump"):
		if Input.is_action_pressed("move_jump") and jumpHold.time_left > 0:
			return jumpGravity
		else:
			return jumpGravity * shortJumpScale
	else:
		return fallGravity

func on_enemy_hit():
	health -= 1
	spriteAnim.play("Hurt")
	print(health)

func _on_drop_off_enter(body: Node2D) -> void:
	if body == self:
		for i in collectedChildren:
			i.saved = true
		collectedChildren.clear()
