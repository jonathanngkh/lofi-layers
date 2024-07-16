extends TextureRect

var hover := false
var placed := false

signal note_placed(placed_note)
signal note_removed(removed_note)

@onready var natural_sprite := preload("res://natural.tscn")
#@onready var sharp_sprite := preload()
#@onready var flat_sprite := preload()
#@onready var flat_sprite := preload()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	modulate.a = 0.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	for child in get_children():
		for grandchild in child.get_children():
			grandchild.mouse_filter = MOUSE_FILTER_IGNORE


func _on_mouse_entered() -> void:
	hover = true
	#if placed == false:
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
			note_placed.emit(self)
			modulate.a = 1.0
		elif placed == true:
			var natural_spawn = natural_sprite.instantiate()
			add_child(natural_spawn)
		
		
	if event_is_mouse_right_click and hover == true and placed == true:
		placed = false
		note_removed.emit(self)
		modulate.a = 0.0
