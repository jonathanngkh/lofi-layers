class_name HurtBox
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner.is_in_group("player"):
		set_collision_layer_value(2, true)
	elif owner.is_in_group("enemy"):
		set_collision_layer_value(3, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
