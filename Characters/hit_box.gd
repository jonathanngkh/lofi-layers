class_name HitBox
extends Area2D

signal hit_signal()

# previously_hit_hurtboxes is manually reset in owner's attack class when attack state is entered
var previously_hit_hurtboxes := []
var damage = 0
var tone := ""
var launch := false
var solfege_note_name_dict := {
	"Do": ["C", 4],
	"Re": ["D", 4],
	"Mi": ["E", 4],
	"Fa": ["F", 4],
	"So": ["G", 4],
	"La": ["A", 4],
	"Ti": ["B", 4],
}

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
				if area.owner.has_method("receive_hit"):
					if not hit_signal.is_connected(area.owner.receive_hit):
						hit_signal.connect(area.owner.receive_hit)
						if owner.name == "WarriorCharacterBody2D":
							var victim_note = area.owner.note_health[-1]
							owner.saved_notes.append(victim_note)
							owner.get_node("SamplerInstrument").play_note(solfege_note_name_dict[victim_note][0], solfege_note_name_dict[victim_note][1])
						hit_signal.emit()
					hit_signal.disconnect(area.owner.receive_hit)
					print(owner.name + ' hit ' + area.owner.name)
					## could affect rhythms:
					#var tween = create_tween()
					#tween.tween_property(Engine, "time_scale",  1.0, 0.2).from(0.5)
				#elif area.get_parent().has_method("receive_hit"):
					#if not hit_signal.is_connected(area.get_parent().receive_hit):
						#hit_signal.connect(area.get_parent().receive_hit)
					#hit_signal.emit()
					#hit_signal.disconnect(area.get_parent().receive_hit)
					#print(owner.name + ' hit ' + area.get_parent().name)
					## could affect rhythms:
					#var tween = create_tween()
					#tween.tween_property(Engine, "time_scale",  1.0, 0.2).from(0.5)


func _area_exited(area_that_exited: HurtBox) -> void:
	if previously_hit_hurtboxes.has(area_that_exited):
		previously_hit_hurtboxes.erase(area_that_exited)
