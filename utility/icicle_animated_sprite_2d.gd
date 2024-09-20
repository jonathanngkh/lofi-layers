extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	$Timer.start()
	$Timer.timeout.connect(_on_timeout)
	animation_finished.connect(_on_animation_finished)
	$HitBox.previously_hit_hurtboxes = []
	$HitBox.freeze = true
	$HitBox.process_mode = Node.PROCESS_MODE_INHERIT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timeout() -> void:
	play("break")
	$HitBox.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_animation_finished() -> void:
	if animation == "break":
		queue_free()
