extends Node2D

@onready var player : PhysicsBody2D = $"../../../Player"
@onready var camera : Camera2D = $"../../../Camera2D"
@onready var room = self.get_parent()

signal Player_Entered(roomTopLeft : Vector2)

func _ready() -> void:
	Player_Entered.connect(camera.on_room_switch)

func on_player_enter(body: Node2D) -> void:
	if body != player:
		return
	
	Player_Entered.emit(room.position)
	
	
