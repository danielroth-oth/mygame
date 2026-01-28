class_name InventoryUI
extends GridContainer

const INVENTORY_SLOT = preload("res://GUI/Pause Menu/inventory/inventorySlot.tscn")

@export var data : InventoryData

var focus_index := 0

func _ready():
	# Inventory aktualisieren, wenn Menü gezeigt wird oder Daten sich ändern
	PausMenu.shown.connect(update_inventory)
	PausMenu.hidden.connect(clear_inventory)
	data.changed.connect(on_inventory_changed)
	clear_inventory()

func clear_inventory():
	for c in get_children():
		c.queue_free()

func update_inventory():
	clear_inventory()

	for s in data.slots:
		var slot = INVENTORY_SLOT.instantiate()
		add_child(slot)
		slot.slot_data = s
		slot.focus_mode = Control.FOCUS_ALL
		slot.focus_entered.connect(item_focused)

	await get_tree().process_frame

	# Fokus und Navigation setzen
	update_focus_navigation()

	# Erstes Item fokussieren
	if get_child_count() > 0:
		get_child(0).grab_focus()

func item_focused():
	for i in range(get_child_count()):
		if get_child(i).has_focus():
			focus_index = i
			return

func on_inventory_changed():
	var i := focus_index
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	if i < get_child_count():
		get_child(i).grab_focus()

# -------------------------------
# Fokus-Navigation für Pfeile / Controller
# -------------------------------
func update_focus_navigation():
	var count := get_child_count()
	var col := columns  # native GridContainer property

	for i in range(count):
		var slot := get_child(i)

		# Links
		if i % col != 0:
			slot.focus_neighbor_left = get_child(i - 1).get_path()

		# Rechts
		if (i + 1) % col != 0 and i + 1 < count:
			slot.focus_neighbor_right = get_child(i + 1).get_path()

		# Hoch
		if i - col >= 0:
			slot.focus_neighbor_top = get_child(i - col).get_path()
		else:
			# oberste Reihe → aktuell sichtbarer Tab
			var current_tab: Control = null
			if PausMenu.tab_container:
				current_tab = PausMenu.tab_container.get_current_tab_control()
			if current_tab:
				slot.focus_neighbor_top = current_tab.get_path()

		# Runter
		if i + col < count:
			slot.focus_neighbor_bottom = get_child(i + col).get_path()
