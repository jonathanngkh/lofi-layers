class_name HitBox
extends Area2D

signal hit_signal()

# previously_hit_hurtboxes is manually reset in owner's attack class when attack state is entered
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
				# could affect rhythms:
				var tween = create_tween()
				tween.tween_property(Engine, "time_scale",  1.0, 0.2).from(0.5)


func _area_exited(area_that_exited: HurtBox) -> void:
	if previously_hit_hurtboxes.has(area_that_exited):
		previously_hit_hurtboxes.erase(area_that_exited)
