class_name PersistentDataHandler extends Node

signal data_loaded
var value : bool = false
var position : Vector2


func _ready() -> void:
	get_value()
	pass


func set_value() -> void:
	var array = [_get_name(), _get_position_x(), _get_position_y()]
	SaveManager.add_persistent_value(array)
	pass


func get_value() -> void:
	var array = [_get_name(), _get_position_x(), _get_position_y()]
	value = SaveManager.check_persistent_value( array )
	if value:
		get_parent().global_position = SaveManager.get_position_value(array)
	data_loaded.emit()
	pass


func _get_name() -> String:
	#"res://levels/area01/01.tscn/chest/PersistentDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name


func _get_position_x():
	return get_parent().global_position.x
	
func _get_position_y():
	return get_parent().global_position.y
