extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	modulate.a = 0.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	modulate.a = 1.0


func _on_mouse_exited() -> void:
	modulate.a = 0.0


# default: invisible
# hover: visible but dimmed or blinking or something to indicate not confirmed
# pressed: stays pressed and becomes visible, confirmed. maybe animation to indicate it's been "placed"
# later can just check all confirmed ones to read the notes to be played
