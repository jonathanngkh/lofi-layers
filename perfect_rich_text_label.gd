extends RichTextLabel

var max_glow := Color(0.5, 3.5, 0.5)
var min_glow := Color(0.5, 2.5, 0.5)
var tween_duration := 60.0/220.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vary_glow()


func vary_glow() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "theme_override_colors/default_color", min_glow, tween_duration).from(max_glow)
	tween.tween_property(self, "theme_override_colors/default_color", max_glow, tween_duration).from(min_glow)
	tween.play()
