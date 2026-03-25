extends Button

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	$"/root/Game".resolve_turn()
