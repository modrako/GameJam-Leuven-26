extends Enemy

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var enemySpeedUp: float = 2
@export var baseEnemyVelocity:float = 20
var enemyspeed: float
var EnemyLookX = -1
var State = States.HIDING
var animationSet:bool = true
enum States{
	HIDING,
	ATTACK
}

func _ready() -> void:
	enemyspeed = baseEnemyVelocity
	super._ready()
func _process(_delta: float) -> void:
	if target.LookX == EnemyLookX:
		if State == States.HIDING :
			animationSet = false
		State = States.ATTACK
	else:
		if State == States.ATTACK:
			animationSet = false
		State = States.HIDING
	if global_position.direction_to(target.position).x >0:
		animated_sprite_2d.flip_h = true
		EnemyLookX = 1
	else:
		animated_sprite_2d.flip_h = false
		EnemyLookX = -1
	if animationSet == false:
		animationSet = true
		match State:
			States.ATTACK:
				animated_sprite_2d.play("AttackTransition")
			States.HIDING:
				animated_sprite_2d.play("HidingTransition")
	
func _physics_process(delta: float) -> void:
	print(animated_sprite_2d.animation)
	if State == States.ATTACK:
		enemyspeed += enemySpeedUp+ delta
		move_and_collide(global_position.direction_to(target.global_position) * enemyspeed * delta)
		audio_stream_player_2d.volume_db = 0
	if State == States.HIDING:
		enemyspeed = baseEnemyVelocity
		audio_stream_player_2d.volume_db = -99

func _on_on_body_entered(_body: Node2D) -> void:
	if _body != target:
		return
	enemyspeed = baseEnemyVelocity
	super.dealDamage(position)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "AttackTransition":
		animated_sprite_2d.play("Attacking")
	if animated_sprite_2d.animation == "HidingTransition":
		animated_sprite_2d.play("Hiding")
