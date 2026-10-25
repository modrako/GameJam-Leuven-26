extends Control
@onready var current_hp_label: Label = $GuiPlayer/CurrentHpLabel
@onready var max_hp: Label = $GuiPlayer/CurrentHpLabel/MaxHp
@onready var ghost_amount: Label = $GuiPlayer/GhostAmount
@onready var max_ghosts: Label = $GuiPlayer/GhostAmount/MaxGhosts
@onready var ghost_left: Label = $GhostLeft
@onready var ghosts: Node = $"../../Ghosts"
@onready var player: CharacterBody2D = $"../../Player"
@onready var animation_player: AnimationPlayer = $GhostLeft/AnimationPlayer

func _process(delta: float) -> void:
	current_hp_label.text = str(player.health)
	max_hp.text = str(player.maxHealth)
	ghost_amount.text  = str(len(player.collectedChildren))
	max_ghosts.text = str(player.MAX_CHILDREN)
	ghost_left.text = str(ghosts.get_child_count())
	
	
func _on_player_ghost_dropped_off() -> void:
	
	animation_player.play("Show")
	
