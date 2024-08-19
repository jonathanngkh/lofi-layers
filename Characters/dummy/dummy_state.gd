# Boilerplate class to get full autocompletion and type checks for the `Player` when coding the player's states.
class_name DummyState
extends State

# Typed reference to the Player node.
var dummy: Dummy

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
	await owner.ready
	
	# The `as` keyword casts the `owner` variable to the `Player` type. If the `owner` is not a `Player`, we'll get `null`.
	dummy = owner as Dummy
	
	# This check will tell us if we inadvertently assign a derived state script in a scene other than `Player.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
	assert(dummy != null)
