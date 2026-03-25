extends RefCounted

class_name Combatant

var name: String
var stance: Enums.Stance = Enums.Stance.Guard
var alertness: int = 75
var emotional_states: Dictionary[Enums.EmotionType, int] = {
	Enums.EmotionType.Frustration: 0,
	Enums.EmotionType.Fear: 0,
}
var health_states: Enums.HealthStatus = Enums.HealthStatus.Healthy
var stamina: int = 10
var action_queue: Array[String]
var is_force_exposed: bool = false

func _init(_name: String) -> void:
	name = _name

func is_dead() -> bool:
	return health_states == Enums.HealthStatus.Dead