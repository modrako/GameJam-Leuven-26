extends Enemy

@onready var shoot_timer: Timer = $ShootTimer
@export var target:CharacterBody2D
@export var projectile:Boomerang
@export var timerVariance:float = 5
@export var timerBase:float = 15
@export var rotationSpeed:float = 0
@export var distanceFromPlayer:float = 3
var angle = 0
var angleDirection = 1
var State:States = States.SPIN

enum States{
	SPIN,
	ATTACK,
}

func _ready() -> void:
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
	position = target.global_position + Vector2(cos(angle), sin(angle)) * distanceFromPlayer
	
func dealDamage() -> void:
	print("die")
	
func _onBoomerangReturned() -> void:
	setAndStartTimer()
	State = States.SPIN
	
func setAndStartTimer() -> void:
	shoot_timer.wait_time =timerBase + randf_range(-timerVariance/2,timerVariance/2)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	projectile.targetPosition = target.global_position
	State = States.ATTACK
	angleDirection *= -1
	Attack.emit()
