extends Control

signal element_selected(slot_node: Node, element_id: String)

var troops: Array[SelectableElement]
var empty_unit := SelectableElement.new("empty", load("res://images/redcross.png"))

func _init() -> void:
	troops.append(SelectableElement.new("A", load("res://images/MageLady.png")))
	troops.append(SelectableElement.new("B", load("res://images/MageMan.png")))
	troops.append(SelectableElement.new("C", load("res://images/PalLady.png")))
	troops.append(SelectableElement.new("D", load("res://images/PalMan.png")))
	troops.append(SelectableElement.new("E", load("res://images/RangerLady.png")))
	troops.append(SelectableElement.new("F", load("res://images/RangerMan.png")))

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
