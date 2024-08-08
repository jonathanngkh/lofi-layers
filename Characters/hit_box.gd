class_name HitBox
extends Area2D

signal hit_signal()

var previously_hit_hurtboxes := []
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 2
	area_exited.connect(_area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for area in get_overlapping_areas():
		if not previously_hit_hurtboxes.has(area):
			if not area.owner == owner:
				previously_hit_hurtboxes.append(area)
				if not hit_signal.is_connected(area.owner.receive_hit):
					hit_signal.connect(area.owner.receive_hit)
				hit_signal.emit()
				print(owner.name + ' hit ' + area.owner.name)


func _area_exited(area_that_exited: HurtBox) -> void:
	if previously_hit_hurtboxes.has(area_that_exited):
		previously_hit_hurtboxes.erase(area_that_exited)
