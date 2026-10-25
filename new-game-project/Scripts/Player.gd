extends CharacterBody2D

class_name Player
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
@onready var collider = $CollisionShape2D
@onready var walk: AudioStreamPlayer = $Walk
@onready var hit_sfx: AudioStreamPlayer = $HitSfx
@onready var death_sfx: AudioStreamPlayer = $DeathSfx
@onready var jump_sfx: AudioStreamPlayer = $Jump

var jumpImpulse : float = -2 * jumpHeight / timeToPeak
var jumpGravity : float = CalculateGravity(timeToPeak)
var fallGravity : float = CalculateGravity(timeToDescend)
var shortJumpScale := 3
var canJump = false
var IsPlayerInKnockBack: bool = false
var WasInAirLastFrame = false
var LookX = 1
#endregion
#TODO: Coyote Time
#TODO: Jump buffer

@export var maxHealth := 5
@onready var spriteAnim = $AnimatedSprite2D
var health: int

const MAX_CHILDREN := 3
var collectedChildren = []

var alive = true

signal GhostDroppedOff(ghost : RigidBody2D)

func _ready() -> void:
	health = maxHealth
func _physics_process(delta: float) -> void:
	if not alive:
		return
	if velocity.x != 0 and is_on_floor() and walk.playing == false:
		walk.play()
	elif velocity.x == 0 or !is_on_floor():
		walk.stop()
		
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
		LookX = -1
		spriteAnim.play("Walk")
		velocity.x = -moveSpeed
	elif Input.is_action_pressed("move_right"):
		spriteAnim.flip_h = false
		LookX = 1
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
			jump_sfx.play()

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
		health -= 1
		if health <= 0:
			alive = false
			var disableCollision = func(): collider.disabled = true
			disableCollision.call_deferred()
			spriteAnim.play("Death")
			death_sfx.play()
			Die()
		else:
			#knockback + animations
			if enemyPosition.direction_to(position).x > 0:
				velocity.x = knockBackStrength/2
			else:
				velocity.x = -knockBackStrength/2
			velocity.y = -knockBackStrength
			IsPlayerInKnockBack = true
			spriteAnim.play("Hurt")
			animation_player.play("Hurt")
			i_frames.start()
			knock_back_timer.start()
			WasInAirLastFrame = true
			hit_sfx.play()

func _on_drop_off_enter(body: Node2D) -> void:
	if body == self and not collectedChildren.is_empty():
		for i in collectedChildren:
			if i.saved == true:
				continue
			i.saved = true
			i.Save()
			GhostDroppedOff.emit(i)


func AnimateIframes():
	var flashInterval:float = 0.25
	var flashPoint:float = fmod(i_frames.time_left, flashInterval)
	spriteAnim.modulate = Color(1,1,1,flashPoint*3)

func Die():
	var deathAnim : Tween = create_tween().bind_node(self)
	
	var originalScale = scale
	deathAnim.tween_property(self, "scale", scale * 1.2, 0.2)
	deathAnim.tween_property(self, "scale", originalScale, 0.2)
	
	var deathBounceUp = Vector2(position.x, position.y - 100)
	deathAnim.set_ease(Tween.EASE_OUT)
	deathAnim.tween_property(self, "position", deathBounceUp, position.distance_to(deathBounceUp) / 300)
	
	deathAnim.set_ease(Tween.EASE_IN)
	var fallTarget := Vector2(position.x, 700) #TODO: Proper target calc
	deathAnim.tween_property(self, "position", fallTarget, fallTarget.y / fallGravity)
	var endGame = func(): get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	deathAnim.tween_callback(endGame)
