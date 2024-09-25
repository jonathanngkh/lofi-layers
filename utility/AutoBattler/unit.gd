@tool
class_name Unit
extends Area2D

@export var stats : UnitStats : set = set_stats

@onready var skin : Sprite2D = $Skin
@onready var health_bar : ProgressBar = $HealthBar
@onready var mana_bar : ProgressBar = $ManaBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	skin.region_rect.position = Vector2(stats.skin_coordinates) * Arena.CELL_SIZE
