extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "projectile"
	animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if animation == "impact":
		queue_free()
