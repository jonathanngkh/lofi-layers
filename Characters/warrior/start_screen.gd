extends ColorRect

@onready var game_started = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("light_attack"):
		if game_started == false:
			game_started = true
			$AudioStreamPlayer.play()
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.5)
	
