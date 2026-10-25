extends Enemy

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var enemySpeedUp: float = 2
@export var baseEnemyVelocity:float = 20
var enemyspeed: float
var EnemyLookX = -1
func _ready() -> void:
	enemyspeed = baseEnemyVelocity
	super._ready()
func _process(_delta: float) -> void:
	if global_position.direction_to(target.position).x >0:
		animated_sprite_2d.flip_h = true
		EnemyLookX = 1
	else:
		animated_sprite_2d.flip_h = false
		EnemyLookX = -1

func _physics_process(delta: float) -> void:
	if target.LookX == EnemyLookX:
		enemyspeed += enemySpeedUp+ delta
		move_and_collide(global_position.direction_to(target.global_position) * enemyspeed * delta)
		audio_stream_player_2d.volume_db = 0
	else:
		enemyspeed = baseEnemyVelocity
		audio_stream_player_2d.volume_db = -99
func _on_on_body_entered(_body: Node2D) -> void:
	if _body != target:
		return
	enemyspeed = baseEnemyVelocity
	super.dealDamage(position)
