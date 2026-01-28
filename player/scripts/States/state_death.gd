class_name StateDeath extends State

@export var exhaust_audio : AudioStream
@onready var audio = $"../../Audio/AudioStreamPlayer2D"



func init() -> void :
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	player.animation_player.play("death")
	audio.stream = exhaust_audio
	audio.play()
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null ) #pass in game over music
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	pass


func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	return null
