class_name Stats extends PanelContainer


@onready var label_level = $VBoxContainer/HBoxContainer/Label_level
@onready var label_xp = $VBoxContainer/HBoxContainer2/Label_xp
@onready var label_attack = $VBoxContainer/HBoxContainer3/Label_attack
@onready var label_defense = $VBoxContainer/HBoxContainer4/Label_defense


func _ready() -> void :
	PausMenu.shown.connect( update_stats )


func update_stats() -> void:
	var _p : Player = PlayerManager.player
	label_level.text = str( _p.level )
	
	if _p.level < PlayerManager.level_requirements.size():
		label_xp.text = str( _p.xp ) + "/" + str(PlayerManager.level_requirements[ _p.level ])
	else:
		label_xp.text = "MAX LVL"
	
	
	label_attack.text = str( _p.attack )
	label_defense.text = str( _p.defense )
	pass
