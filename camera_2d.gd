extends Camera2D

var start_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position.y = start_position
