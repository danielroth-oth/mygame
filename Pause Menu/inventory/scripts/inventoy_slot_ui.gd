class_name InventorySlotUI extends Button

var slot_data : SlotData : set = set_slot_data

@onready var texture_rect = $TextureRect
@onready var label = $Label

func _ready():
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	#pressed.connect(item_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		item_pressed()

func set_slot_data(value : SlotData):
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)

func item_focused():
	if slot_data != null:
		if slot_data.item_data != null:
			PausMenu.update_item_description(slot_data.item_data.description)
			PausMenu.update_item_texture(slot_data.item_data.texture)

func item_unfocused():
	PausMenu.update_item_description("")

func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str(slot_data.quantity)
