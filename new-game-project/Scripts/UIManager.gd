extends Control
@onready var current_hp_label: Label = $GuiPlayer/CurrentHpLabel
@onready var max_hp: Label = $GuiPlayer/CurrentHpLabel/MaxHp
@onready var ghost_amount: Label = $GuiPlayer/GhostAmount
@onready var max_ghosts: Label = $GuiPlayer/GhostAmount/MaxGhosts
@onready var ghost_left: Label = $GhostLeft
@onready var ghosts: Node = $"../../Ghosts"
@onready var player: CharacterBody2D = $"../../Player"

func _process(delta: float) -> void:
	current_hp_label.text = str(player.health)
	max_hp.text = str(player.maxHealth)
	print(ghost_left.text)
	ghost_amount.text  = str(len(player.collectedChildren))
	max_ghosts.text = str(player.MAX_CHILDREN)
	

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	ghost_left.text = str(ghosts.get_child_count())
