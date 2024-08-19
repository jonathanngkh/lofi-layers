# Boilerplate class to get full autocompletion and type checks for the `Player` when coding the player's states.
extends State
class_name RogueGoblinState

# Typed reference to the Player node.
var rogue_goblin: RogueGoblin

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
	await owner.ready
	
	# The `as` keyword casts the `owner` variable to the `Player` type. If the `owner` is not a `Player`, we'll get `null`.
	rogue_goblin = owner as RogueGoblin
	
	# This check will tell us if we inadvertently assign a derived state script in a scene other than `Player.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
	assert(rogue_goblin != null)
