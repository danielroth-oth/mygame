class_name State_Idle extends State

@onready var walk : State = $"../Walk"
@onready var attack :State = $"../Attack"
@onready var roll : State = $"../Roll"

func _ready():
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	pass


func Process( _delta : float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	
	
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action("roll"):
		return roll
	return null
