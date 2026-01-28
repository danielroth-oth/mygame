class_name State extends Node

static var player : Player
static var state_machine: PlayerStateMachine

func _ready():
	pass


func init() -> void :
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	pass


func Process( _delta : float ) -> State:
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	return null
