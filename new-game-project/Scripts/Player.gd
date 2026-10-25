extends CharacterBody2D

#region movementVariables
@export var moveSpeed := 300
@export var knockBackStrength:float = 40;
@export var jumpHeight : float = 200
@export var timeToFullJump : float = 0.2
@export var timeToPeak : float = 0.6
@export var timeToDescend : float = 0.4
@onready var jumpHold : Timer = $Timer
@onready var i_frames: Timer = $IFrames
@onready var knock_back_timer: Timer = $KnockBackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var jumpImpulse : float = -2 * jumpHeight / timeToPeak
var jumpGravity : float = CalculateGravity(timeToPeak)
var fallGravity : float = CalculateGravity(timeToDescend)
var shortJumpScale := 3
var canJump = false
var IsPlayerInKnockBack: bool = false
var WasInAirLastFrame = false
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
	if is_on_floor():
		canJump = true
		if IsPlayerInKnockBack && knock_back_timer.time_left <= 0:
			animation_player.play("HitGround")
			velocity = Vector2.ZERO
			IsPlayerInKnockBack = false
		if WasInAirLastFrame:
			animation_player.play("HitGround")
			WasInAirLastFrame = false
			
	if !IsPlayerInKnockBack:
		Move()
		Jump()
	if not is_on_floor():
		if !IsPlayerInKnockBack:
			if velocity.y <= 0:
				spriteAnim.play("Rise")
			else:
				spriteAnim.play("Fall")
				if !animation_player.is_playing() && WasInAirLastFrame == true:
					animation_player.play("Falling")
	
	if i_frames.time_left >0:
		AnimateIframes()
	else:
		spriteAnim.modulate = Color(1,1,1,1)
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
			animation_player.play("Jump")
			WasInAirLastFrame = true
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

func on_enemy_hit(enemyPosition: Vector2):
	if i_frames.time_left <= 0:
		if enemyPosition.direction_to(position).x > 0:
			velocity.x = knockBackStrength/2
		else:
			velocity.x = -knockBackStrength/2
		velocity.y = -knockBackStrength
		health -= 1
		IsPlayerInKnockBack = true
		spriteAnim.play("Hurt")
		animation_player.play("Hurt")
		i_frames.start()
		knock_back_timer.start()
		WasInAirLastFrame = true
	

func _on_drop_off_enter(body: Node2D) -> void:
	if body == self:
		for i in collectedChildren:
			if i.saved == true:
				continue
			i.saved = true
			i.Save()
		collectedChildren.clear()
	
func AnimateIframes():
	var flashInterval:float = 0.25
	var flashPoint:float = fmod(i_frames.time_left, flashInterval)
	spriteAnim.modulate = Color(1,1,1,flashPoint*3)
	
