extends Node2D

@onready var enemies : Node = $Enemies
@onready var door := $DropArea
@onready var ghosts = $Ghosts
@onready var player := $Player
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
	EnemyTypes.weeping, EnemyTypes.boomerang, EnemyTypes.boomerang, EnemyTypes.chaser]

func _ready() -> void:
	maxChildren = ghosts.get_child_count()
	numChildren = maxChildren
	
	SpawnEnemy()

func _on_ghosts_child_exiting_tree(_node: Node) -> void:
	numChildren -= 1
	
	if numChildren % 3 == 0 and not numChildren == 0:
		difficulty += 1
		SpawnEnemy()

func SpawnEnemy():
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
