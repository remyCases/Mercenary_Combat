extends Control

signal element_selected(slot_node: Node, element_id: String)

var troops: Array[SelectableElement]
var empty_unit := SelectableElement.new("empty", load("res://images/redcross.png"))

func _init() -> void:
	troops.append(SelectableElement.new("wild_aggressor", load("res://images/MageLady.png")))
	troops.append(SelectableElement.new("mind_player", load("res://images/MageMan.png")))
	troops.append(SelectableElement.new("sharp_sentinel", load("res://images/PalLady.png")))

	element_selected.connect(_on_element_selected)

func _on_element_selected(slot_node: Node, element: SelectableElement):
	for slot in get_children():
		if slot != slot_node \
			and slot.current_element == element \
			and slot.current_element != empty_unit:
			slot._set_element(empty_unit)

func get_troops() -> Array[SelectableElement]:
	var elements = troops.duplicate()
	elements.push_front(empty_unit)
	
	return elements
