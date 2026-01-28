extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player = $AudioStreamPlayer
@onready var tab_container = $TabContainer
@onready var item_description = $TabContainer/Inventory/ItemDescription
@onready var button_quit = $TabContainer/Settings/VBoxContainer/Button_Quit
@onready var texture_rect = $TabContainer/Inventory/TextureRect

var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	tab_container.tab_changed.connect(_on_tab_changed)
	button_quit.pressed.connect( _on_quit_pressed )

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			if DialogSystem.is_active:
				return
			#if SafeLoadMenu.is_active:
				#return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
	
	if is_paused:
		if event.is_action_pressed("right_bumper"):
			change_tab(1)
		elif  event.is_action_pressed("left_bumper"):
			change_tab(-1)

func show_pause_menu():
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()

func hide_pause_menu():
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func update_item_description( new_text : String):
	item_description.text = new_text

func update_item_texture( new_texture : Texture2D):
	texture_rect.texture = new_texture

func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

func _on_tab_changed(_index: int) -> void:
	await get_tree().process_frame
	var tab: Control = tab_container.get_current_tab_control()
	if not tab:
		return

	# Tab selbst fokussieren
	var focusable: Control = _find_first_focusable(tab)
	if focusable:
		focusable.grab_focus()

	# Tab nach unten → erstes Inventory Item
	var inv := $Inventory/InventoryUI
	if inv and inv.get_child_count() > 0:
		focusable.focus_neighbor_down = inv.get_child(0).get_path()




func _find_first_focusable(node: Node) -> Control:
	for c in node.get_children():
		if c is Control and c.focus_mode != Control.FOCUS_NONE:
			return c
		var found := _find_first_focusable(c)
		if found != null:
			return found
	return null

func change_tab( _i : int = 1 ) -> void:
	tab_container.current_tab = wrapi( 
			tab_container.current_tab + _i,
			0,
			tab_container.get_tab_count()
		 )
	tab_container.get_tab_bar().grab_focus()
