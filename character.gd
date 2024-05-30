extends TextureRect

@export var initial_expression := "determined"
@export var blink_duration := 0.09
@export var blink_interval_min := 0.4
@export var blink_interval_max := 4.2
var blink_interval := randf_range(blink_interval_min, blink_interval_max)
@onready var expressions_dictionary: Dictionary = {
	"angry": {"base": preload("res://assets/characters/expressions/emotion_angry.png"), "blink": preload("res://assets/characters/expressions/emotion_angry_blink.png")},
	"determined": {"base": preload("res://assets/characters/expressions/emotion_determined.png"), "blink": preload("res://assets/characters/expressions/emotion_determined_blink.png")},
	"regular": {"base": preload("res://assets/characters/expressions/emotion_regular.png"), "blink": preload("res://assets/characters/expressions/emotion_regular_blink.png")},
	"sad": {"base": preload("res://assets/characters/expressions/emotion_sad.png"), "blink": null},
	"euphoric": {"base": preload("res://assets/characters/expressions/emotion_euphoric.png"), "blink": null},
	"happy": {"base": preload("res://assets/characters/expressions/emotion_happy.png"), "blink": null}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Expression.texture = expressions_dictionary[initial_expression]["base"]
	$BlinkIntervalTimer.connect("timeout", _on_interval_timer_timeout)
	$BlinkIntervalTimer.wait_time = blink_interval
	$BlinkDurationTimer.connect("timeout", _on_duration_timer_timeout)
	$BlinkDurationTimer.wait_time = blink_duration


func _on_interval_timer_timeout() -> void:
	blink_interval = randf_range(blink_interval_min, blink_interval_max)
	if expressions_dictionary[initial_expression]["blink"] != null:
		$Expression.texture = expressions_dictionary[initial_expression]["blink"]
	$BlinkIntervalTimer.wait_time = blink_interval


func _on_duration_timer_timeout() -> void:
	$Expression.texture = expressions_dictionary[initial_expression]["base"]
