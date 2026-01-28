class_name State_Walk extends State

@export var move_speed : float = 100.0
@onready var idle : State = $"../Idle"
@onready var attack :State = $"../Attack"
@onready var roll : State = $"../Roll"

func _ready():
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	pass


func Process( _delta : float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.direction = player.direction.normalized()
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action("attack"):
		return attack
	if _event.is_action("roll"):
		return roll
	return null
