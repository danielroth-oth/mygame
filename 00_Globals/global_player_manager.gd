extends Node

const PLAYER = preload("res://player/player_character.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/Pause Menu/inventory/player_invetory.tres")


signal interact_pressed
signal player_leveled_up

var player : Player
var player_spawned : bool = false



#var level_requirements = [ 0, 50, 100, 200, 400, 800, 1500, 3000, 6000, 12000, 25000 ]
var level_requirements = [ 0, 5, 10, 20, 40,]


# Bridge up down test code
enum HeightLevel {
	GROUND,
	BRIDGE
}

var is_on_bridge : bool = false

var height_level: HeightLevel = HeightLevel.GROUND



func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true



func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass



func set_health( hp : int, max_hp: int )-> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )


func reward_xp( _xp : int ) -> void:
	player.xp += _xp
	#check for level advancement
	check_for_level_advance()
	


func check_for_level_advance() -> void:
	if player.level >= level_requirements.size():
		return
	if player.xp >= level_requirements[ player.level ] :
		player.level += 1
		player.attack += 1
		player.defense += 1
		player_leveled_up.emit()
		check_for_level_advance()
	pass


func set_player_position( _new_pos : Vector2 ) -> void :
	player.global_position = _new_pos


func set_as_parent( _p : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )
	
	
	
func unparent_player( _p : Node2D ) -> void:
		_p.remove_child( player )


func interact() -> void:
	interact_pressed.emit()


func update_height():
	if height_level == HeightLevel.BRIDGE:
		player.z_index = 10
		player.collision_layer = 1
		player.set_collision_mask_value(5, false)
		player.set_collision_mask_value(8, true)
		is_on_bridge = true
	else:
		player.z_index = 0
		player.set_collision_mask_value(5, true)
		player.set_collision_mask_value(8, false)
		is_on_bridge = false
