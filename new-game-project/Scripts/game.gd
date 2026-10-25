extends Node2D

@onready var enemies : Node = $Enemies
@onready var door := $DropArea
@onready var ghosts = $Ghosts
@onready var player := $Player
@onready var endingSpawnRoot = $EndingSpawns
@onready var spawnInterval = $EndingInterval
var endingSpawns = []
const ENEMY_CHASER = preload("uid://2jiv4jnq2lkl")
const ENEMY_BOOMERANG = preload("uid://dv6km1irfpcfs")
const ENEMY_WEEPING = preload("uid://c7nyfoqu0ihdv")

var maxChildren : int
var numChildren : int

enum Difficulty{
	easy, medium, hard, final
}
@export var difficulty = 0

enum EnemyTypes{
	chaser,
	boomerang,
	weeping,
}

@export var enemyPlan : Array[EnemyTypes] = [
	EnemyTypes.weeping, EnemyTypes.boomerang, EnemyTypes.boomerang, EnemyTypes.chaser, EnemyTypes.chaser]

func _ready() -> void:
	maxChildren = ghosts.get_child_count()
	numChildren = maxChildren
	
	for i in endingSpawnRoot.get_children():
		endingSpawns.push_back(i.global_position)
	
	SpawnEnemy()

func _on_ghosts_child_exiting_tree(_node: Node) -> void:
	numChildren -= 1
	
	numChildren = max(numChildren, 0)
	
	if numChildren % 3 == 0 and not numChildren == 0:
		difficulty += 1
		SpawnEnemy()

func SpawnEnemy():
	if numChildren == 0:
		return
	var newEnemy
	var difficultyIndex : int = difficulty
	if enemyPlan[difficultyIndex] == EnemyTypes.chaser:
		newEnemy = ENEMY_CHASER.instantiate()
	elif enemyPlan[difficultyIndex] == EnemyTypes.boomerang:
		newEnemy = ENEMY_BOOMERANG.instantiate()
	elif enemyPlan[difficultyIndex] == EnemyTypes.weeping:
		newEnemy = ENEMY_WEEPING.instantiate()
		
	newEnemy.target = player
	newEnemy.position = Vector2(door.position.x, door.position.y - 300)
	enemies.add_child(newEnemy)

func _on_drop_area_player_leave() -> void:
	if numChildren <= 0:
		BadEnding()
	else:
		get_tree().change_scene_to_file("res://Scenes/GoodEnding.tscn")

func BadEnding():
	var SpawnGhost = func(index : int): 
		var enemy
		enemy = ENEMY_CHASER.instantiate()
		enemy.target = player
		enemy.position = endingSpawns[index]
		enemies.add_child(enemy)
		pass
	
	door.queue_free()
	var tween : Tween = create_tween()
	tween.tween_callback(SpawnGhost.bind(0))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(1))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(2))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(3))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(4))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(5))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(6))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(7))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(8))
	tween.tween_interval(0.1)
	tween.tween_callback(SpawnGhost.bind(9))
	tween.tween_interval(2)
	tween.tween_callback(LoadEnding)

func LoadEnding():
	get_tree().change_scene_to_file("res://Scenes/TrueEnd.tscn")
