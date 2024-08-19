extends TextureRect
@export var tween_duration = 0.1
var spinning = false

var solfege_ball_positions := [
	Vector2(-11, -45), # Do
	Vector2(22, -28), # Re
	Vector2(27, 0), # Mi
	Vector2(7, 24), # Fa
	Vector2(-30, 24), # So
	Vector2(-47, 0), # La
	Vector2(-42, -28), # Ti
]
@export var solfege_ball_positions_index := 0

func _process(delta: float) -> void:
	if not position == Vector2(-11, -45) and spinning:
		var tween = create_tween()
		tween.tween_property(self, "self_modulate:a", 0.1, tween_duration)
		#self_modulate.a = 0.1
	
	if not position == Vector2(-11, -45) and not spinning:
		var tween = create_tween()
		tween.tween_property(self, "self_modulate:a", 0, tween_duration)
		#self_modulate.a = 0
	if position == Vector2(-11, -45):
		var tween = create_tween()
		tween.tween_property(self, "self_modulate:a", 1, tween_duration)
		#self_modulate.a = 1
	

func solfege_forward() -> void:
	spinning = true
	if solfege_ball_positions_index > - (solfege_ball_positions.size() - 1):
		solfege_ball_positions_index -= 1
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, tween_duration)
		await tween.finished
		spinning = false
	else:
		solfege_ball_positions_index = 0
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, tween_duration)
		await tween.finished
		spinning = false
		



func solfege_backward() -> void:
	if solfege_ball_positions_index < solfege_ball_positions.size() - 1:
		solfege_ball_positions_index += 1
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 0.2)
	else:
		solfege_ball_positions_index = 0
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 0.2)
