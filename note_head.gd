extends TextureRect

var hover := false
var placed := false

signal note_placed(placed_note)
signal note_removed(removed_note)

@onready var left_crotchet_tail := preload("res://left_crotchet_tail.tscn")
@onready var right_crotchet_tail := preload("res://right_crotchet_tail.tscn")
@onready var natural := preload("res://natural.tscn")
@onready var sharp := preload("res://sharp.tscn")
@onready var flat := preload("res://flat.tscn")
@onready var double_sharp := preload("res://double_sharp.tscn")
@onready var double_flat := preload("res://double_flat.tscn")
@onready var accidentals := [sharp, flat, natural, double_sharp, double_flat]
@onready var accidentals_index := 0
@onready var accidental_symbol_dict := {
	"Sharp": "#",
	"DoubleSharp": "##",
	"Flat": "b",
	"DoubleFlat": "bb",
	"Natural": ""
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	modulate.a = 0.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	for child in get_children():
		child.mouse_filter = MOUSE_FILTER_IGNORE
		if child.name == "InnerHead":
			child.visible = false
		for grandchild in child.get_children():
			grandchild.mouse_filter = MOUSE_FILTER_IGNORE


func _on_mouse_entered() -> void:
	hover = true
	modulate.a = 0.5


func _on_mouse_exited() -> void:
	hover = false
	if placed == false:
		modulate.a = 0.0
	else:
		modulate.a = 1.0


func _input(event: InputEvent) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.pressed
	)
	var event_is_mouse_right_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_RIGHT and
		event.pressed
	)
	if event_is_mouse_click and hover == true:
		if placed == false:
			placed = true
			modulate.a = 1.0
			#if MusicTheoryDB.get_note_value(name.right(2)[0], int(name.right(2)[1])) >= 71:
				#var left_tail_spawn = left_crotchet_tail.instantiate()
				#add_child(left_tail_spawn)
			#else:
				#var right_tail_spawn = right_crotchet_tail.instantiate()
				#add_child(right_tail_spawn)
			note_placed.emit(self)
		elif placed == true:
			if accidentals_index < accidentals.size():
				# remove previous accidental:
				for child in get_children():
					if child.is_in_group("accidental"):
						child.queue_free()
				var accidental_spawn = accidentals[accidentals_index].instantiate()
				add_child(accidental_spawn)
				name = name.left(1) + accidental_symbol_dict[accidental_spawn.name] + name.right(1)
				accidentals_index += 1
				note_placed.emit(self)
			else:
				accidentals_index = 0
				# remove previous accidental
				for child in get_children():
					if child.is_in_group("accidental"):
						child.queue_free()
				name = name.left(1) + name.right(1)
				print(name)
				note_placed.emit(self)
		
		
	if event_is_mouse_right_click and hover == true and placed == true:
		placed = false
		name = name.left(1) + name.right(1)
		modulate.a = 0.0
		self_modulate = "000000"
		accidentals_index = 0
		# remove previous accidental
		for child in get_children():
			if child.is_in_group("accidental"):
				child.queue_free()
			# reset color of innerhead to black
			if child.name == "InnerHead":
				child.visible = false
				child.self_modulate = "000000"
		note_removed.emit(self)
