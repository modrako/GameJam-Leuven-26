extends Enemy

@onready var shoot_sfx: AudioStreamPlayer = $ShootSfx
@onready var reverse_shoot_sfx: AudioStreamPlayer = $ReverseShootSfx

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@export var projectile:Boomerang
@export var timerVariance:float = 5
@export var timerBase:float = 15
@export var rotationSpeed:float = 2
@export var distanceFromTarget:float = 200
var angle = 0
var angleDirection = 1
var State:States = States.SPIN

enum States{
	SPIN,
	ATTACK,
}

signal Attack()

func _ready() -> void:
	super._ready()
	setAndStartTimer()
	projectile.returned.connect(_onBoomerangReturned)
	

func _process(delta: float) -> void:
	match State:
		States.SPIN:
			RotateAroundPlayer(delta)
		States.ATTACK:
			pass
	
func RotateAroundPlayer(delta:float):
	angle += rotationSpeed * delta * angleDirection
	position = target.global_position + Vector2(cos(angle), sin(angle)) * distanceFromTarget
	

func _onBoomerangReturned() -> void:
	setAndStartTimer()
	State = States.SPIN
	anim_sprite.play("ReSpin")
	reverse_shoot_sfx.play()
	
func setAndStartTimer() -> void:
	shoot_timer.wait_time =timerBase + randf_range(-timerVariance,timerVariance)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	projectile.targetPosition = target.global_position
	State = States.ATTACK
	angleDirection *= -1
	Attack.emit()
	anim_sprite.play("Shoot")
	shoot_sfx.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	if State == States.SPIN:
		anim_sprite.play("Idle")
	else:
		anim_sprite.play("Chilling")
