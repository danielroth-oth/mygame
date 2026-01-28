##Quest Manager - Global Script
extends Node


signal quest_updated( q )

const QUEST_DATA_LOCATION : String = "res://quests/"

var quests : Array[ Quest ]
var current_quests : Array = []

func _ready() -> void:
	#gather all quests
	gather_quest_data()
	pass


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		##print(find_quest(load("res://quests/bring_some_coffee.tres") as Quest ))
		##print(find_quest_by_title( "Short Quest" ))
		##print("get_quest_index_by_title:", get_quest_index_by_title("Bring Luna some Coffee"))
		##print("get_quest_index_by_title:", get_quest_index_by_title("short quest"))
		##print("before:", current_quests)
		##update_quest("short quest")
		##update_quest("Bring Luna some Coffee","Find the Coffee", true)
		##update_quest("Bring Luna some Coffee","Bring it to Luna", true)
		##update_quest("Long Quest","step 1")
		##update_quest("Long Quest","step 2")
		#print("quests:", current_quests)
		#print("============================================================")
		#pass
	#pass


func gather_quest_data() -> void:
	#gather all quest resources and add to quest array
	var quest_files : PackedStringArray = DirAccess.get_files_at( QUEST_DATA_LOCATION )
	quests.clear()
	for q in quest_files:
		quests.append( load( QUEST_DATA_LOCATION + "/" + q) as Quest )
	print("quest count:", quests.size())
	pass


	#Update the status of a quest
func update_quest( _title : String, _completed_step: String = "", _is_complete : bool = false ) -> void:
	var quest_index : int = get_quest_index_by_title( _title )
	if quest_index == -1:
		#Quest needs to be added 
		var new_quest : Dictionary = { 
			title = _title,
			is_complete = _is_complete, 
			completed_steps = [] 
		}
		
		if _completed_step != "":
			new_quest.completed_steps.append( _completed_step.to_lower() )
		
		current_quests.append( new_quest )
		quest_updated.emit( new_quest )
		
		#Display Notifaction that quest was added
		PlayerHud.queue_notification( "Quest Started", _title )
		pass
	else:
		var q = current_quests[ quest_index ]
		if _completed_step != "" and q.completed_steps.has( _completed_step ) == false:
			q.completed_steps.append(_completed_step.to_lower() )
			pass
		
		q.is_complete = _is_complete
		
		quest_updated.emit( q )
		
		if q.is_complete == true:
			PlayerHud.queue_notification( "Quest Completed!", _title)
			disperse_quest_rewards( find_quest_by_title( _title ) )
		else:
			PlayerHud.queue_notification( "Quest Updated", _title + ": " + _completed_step )
	pass


func disperse_quest_rewards( _q : Quest ) -> void:
	#give xp and rewards
	var _message : String = str( _q.reward_xp ) + "xp"
	PlayerManager.reward_xp( _q.reward_xp )
	
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item( i.item, i.quantity )
		_message += ", " + i.item.name + " x" + str( i.quantity )
		
	PlayerHud.queue_notification( "Quest Rewards Received", _message )
	pass

	#Provide a quest and return the curent associated with it
func find_quest( _quest : Quest ) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return { title = "not found", is_complete = false, completed_steps = [ '' ] }

	#take title and find quest resource
func find_quest_by_title( _title : String ) -> Quest:
	for q in quests: 
		if q.title.to_lower() == _title.to_lower():
			return q
	return null


#find quest by title name and return index in Quest Array
func get_quest_index_by_title( _title : String ) -> int:
	for i in current_quests.size():
		if current_quests[ i ].title.to_lower() == _title.to_lower():
			return i
	#if Quest not find
	return -1


func sort_quests() -> void:
	var active_quests : Array = []
	var completed_quests : Array = []
	for q in current_quests:
		if q.is_complete:
			completed_quests.append( q )
		else:
			active_quests.append( q )
	active_quests.sort_custom( sort_quest_ascending )
	completed_quests.sort_custom( sort_quest_ascending )
	
	current_quests = active_quests
	current_quests.append_array( completed_quests )
	
	pass


func sort_quest_ascending( a, b ):
	if a.title < b.title:
		return true
	return false
