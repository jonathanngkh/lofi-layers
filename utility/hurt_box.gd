class_name HurtBox
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner.is_in_group("player"):
		collision_layer = 2
	elif owner.is_in_group("enemy"):
		collision_layer = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
