extends Area2D

@onready var player : PhysicsBody2D = $"../Player"
@onready var label: Label = $Label

@onready var closed : Sprite2D = $DoorClosed
@onready var open : Sprite2D = $DoorOpen

signal PlayerExit()

func _on_body_entered(body: Node2D) -> void:
	if body == player and player.collectedChildren.is_empty():
		Open()


func _on_body_exited(body: Node2D) -> void:
	if body == player and player.collectedChildren.is_empty():
		Close()
		
func _process(delta: float) -> void:
	if label.visible == true and Input.is_action_just_pressed("move_down"):
		PlayerExit.emit()
		

func Open() -> void:
	label.visible = true
	closed.visible = false
	open.visible = true

func Close() -> void:
	label.visible = false
	closed.visible = true
	open.visible = false
