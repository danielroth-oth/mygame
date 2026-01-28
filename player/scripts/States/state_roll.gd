class_name State_Roll extends State

var rolling : bool = false

@onready var walk : State = $"../Walk"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../Idle"

@export var invulnerable_duration : float = 0.5


func _ready():
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	animation_player.animation_finished.connect( EndRolling )
	player.UpdateAnimation("roll")
	player.make_invulnerable( invulnerable_duration )
	rolling = true
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndRolling )
	rolling = false
	pass


func Process( _delta : float ) -> State:

	
	if rolling == false :
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	return null


func EndRolling( _newAnimName : String ) -> void:
	rolling = false
