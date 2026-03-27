extends RefCounted

class_name Opponent

var name: String
var icon: Texture
var strategy: Array[String]

func _init(_name: String, _icon: Texture, _strategy: Array[String]) -> void:
    name = _name
    icon = _icon
    strategy = _strategy
