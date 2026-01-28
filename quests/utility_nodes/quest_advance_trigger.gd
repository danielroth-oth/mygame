@tool
@icon("res://quests/utility_nodes/icons/quest_advance.png")
class_name QuestAdvanceTrigger extends QuestNode

signal advanced

@export_category( "Parent Signal Connnection" )
@export var signal_name : String = ""

@onready var sprite_2d = $Sprite2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	sprite_2d.queue_free()
	if signal_name != "":
		if get_parent().has_signal( signal_name ):
			get_parent().connect( signal_name, advance_quest )
	pass



func advance_quest() -> void:
	if linked_quest == null:
		return
	await  get_tree().process_frame
	advanced.emit()
	var _title : String = linked_quest.title
	var _step : String = get_step()
	
	if _step == "N/A":
		_step = ""
	
	print( "advance_quest :" + _title )
	QuestManager.update_quest( _title, _step, quest_complete )
	
	
	pass
