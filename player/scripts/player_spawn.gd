extends Node2D


func _ready():
	await get_tree().create_timer(0.1).timeout
	visible = false
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position( global_position )
		PlayerManager.player_spawned = true
