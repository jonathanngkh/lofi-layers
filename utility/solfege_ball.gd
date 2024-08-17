extends TextureRect

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


func solfege_forward() -> void:
	if solfege_ball_positions_index > - (solfege_ball_positions.size() - 1):
		solfege_ball_positions_index -= 1
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 0.2)
	else:
		solfege_ball_positions_index = 0
		var target_position = solfege_ball_positions[solfege_ball_positions_index]
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 0.2)
