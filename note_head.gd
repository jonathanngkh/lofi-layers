extends TextureRect

var hover := false
var placed := false

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
	if placed == false:
		modulate.a = 1.0


func _on_mouse_exited() -> void:
	hover = false
	if placed == false:
		modulate.a = 0.0


func _input(event: InputEvent) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.pressed
	)
	var event_is_mouse_double_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.double_click
	)
	if event_is_mouse_click and hover == true and placed == false:
		placed = true
		modulate.a = 1.0
	if event_is_mouse_double_click and hover == true and placed == true:
		placed = false
		modulate.a = 0.0

# default: invisible
# hover: visible but dimmed or blinking or something to indicate not confirmed
# pressed: stays pressed and becomes visible, confirmed. maybe animation to indicate it's been "placed"
# later can just check all confirmed ones to read the notes to be played
