extends RefCounted

class_name Action

var name: String
var description: String 
var base_initiative: int
var weight: Enums.ActionWeight
var attack_type: Enums.ActionType
var stamina_cost_hit: int
var stamina_cost_miss: int
var new_stance: Enums.Stance
var prerequisites: Array[String]
var buildup: Dictionary[Enums.EmotionType, int]
var flavor_hit: String
var flavor_miss: String

func _init(
	_name: String,
	_initiative: int,
	_weight: Enums.ActionWeight,
	_attack_type: Enums.ActionType,
	_stamina_hit: int,
	_stamina_miss: int,
	_new_stance: Enums.Stance,
	_hit: String,
	_miss: String
) -> void:
	name = _name
	base_initiative = _initiative
	weight = _weight
	attack_type = _attack_type
	stamina_cost_hit = _stamina_hit
	stamina_cost_miss = _stamina_miss
	new_stance = _new_stance
	flavor_hit = _hit
	flavor_miss = _miss
