extends AnimatedSprite2D

var tween = create_tween()
@onready var hit_box: HitBox = $HitBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "projectile"
	animation_finished.connect(_on_animation_finished)
	hit_box.hit_signal.connect(_on_hit)


func _on_hit(msg) -> void:
	play("impact", 1.5)
	tween.kill()


func _on_animation_finished() -> void:
	if animation == "impact":
		queue_free()
