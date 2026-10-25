extends Area2D

@onready var player : PhysicsBody2D = $"../Player"

@onready var closed : Sprite2D = $DoorClosed
@onready var open : Sprite2D = $DoorOpen

func _on_body_entered(body: Node2D) -> void:
	if body == player and player.collectedChildren.is_empty():
		Open()


func _on_body_exited(body: Node2D) -> void:
	if body == player and player.collectedChildren.is_empty():
		Close()

func Open() -> void:
	closed.visible = false
	open.visible = true

func Close() -> void:
	closed.visible = true
	open.visible = false
