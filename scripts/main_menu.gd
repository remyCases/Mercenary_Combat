extends Control

class_name MainMenu

@onready var start_button = $"VBoxContainer/Button"

func _ready() -> void:
    start_button.disabled = true
    start_button.pressed.connect(_on_start)

func _on_start() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func enable(opponent_id: String) -> void:
    Globals.opponent_id = opponent_id
    start_button.disabled = false

func disable() -> void:
    Globals.opponent_id = ""
    start_button.disabled = true