class_name Boomerang
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var shooter:Enemy
@export var basePower = 40
@export var powerFallOff = 60
@export var rotationSpeed:float = 15
var targetPosition:Vector2
var power: float
var isBeingThrown:bool = false
var goingForward:bool = true
var directionMultiplier = 1

signal returned()

func _ready() -> void:
	power =  basePower
	shooter.Attack.connect(_throw)
	
func _throw():
	isBeingThrown = true
	look_at(targetPosition)

func _process(delta: float) -> void:
	sprite_2d.rotate(rotationSpeed * delta)
	sprite_2d.visible = isBeingThrown
	if !isBeingThrown:
			linear_velocity = Vector2(0,0)
			global_position = shooter.global_position

func _physics_process(delta: float) -> void:
	if isBeingThrown:
		ApplyAndUpdateVelocity(delta)
		
func ApplyAndUpdateVelocity(delta: float):
	apply_force(power 
	* shooter.global_position.direction_to(targetPosition))
	power -= powerFallOff * delta

func _on_boomerang_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == shooter and power <0:
		isBeingThrown = false;
		power = basePower
		returned.emit()

func _on_boomerang_area_2d_body_entered(body: Node2D) -> void:
	shooter.dealDamage() #add check for player
