extends Node2D

const START_LEVEL : String = "res://scenes/Worlds/levels/Start_Area/Cliff.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var new_game_button = $CanvasLayer/VBoxContainer/new_game
@onready var continue_button = $CanvasLayer/VBoxContainer/continue
@onready var quit_button = $CanvasLayer/VBoxContainer/Quit
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func _ready() -> void:
	get_tree().paused = true
	
	
	PlayerHud.visible = false
	PausMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		continue_button.disabled = true
	
	setup_title_screen()
	
	GlobalLevelManager.level_load_started.connect( exit_title_screen )
	
	pass


func setup_title_screen() -> void:
	AudioManager.play_music( music )
	new_game_button.pressed.connect( start_game )
	continue_button.pressed.connect(load_game)
	quit_button.pressed.connect( _on_quit_pressed )
	new_game_button.grab_focus()
	
	new_game_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	quit_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass


func start_game() ->void:
	play_audio( button_press_audio )
	GlobalLevelManager.load_new_level( START_LEVEL, "", Vector2.ZERO)
	pass


func load_game() -> void:
	play_audio( button_press_audio )
	SaveManager.load_game()


func _on_quit_pressed() -> void:
	play_audio( button_press_audio )
	get_tree().quit()

func exit_title_screen() -> void:
	PlayerHud.visible = true
	PausMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass


func play_audio( _a : AudioStream ) -> void:
	audio_stream_player_2d.stream = _a
	audio_stream_player_2d.play()
