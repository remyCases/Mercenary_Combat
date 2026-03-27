extends Control

signal element_selected(slot_node: Node, element: SelectableElement)

var actions: Array[SelectableElement]
var empty_unit := SelectableElement.new("empty", load("res://images/redcross.png"))
var selected_actions: Array[String] = ["", "", ""]

func _init() -> void:
	for i in Globals.ACTION_DATABASE:
		actions.append(SelectableElement.new(i, null))

	element_selected.connect(_on_element_selected)

func _on_element_selected(slot_node: Node, element: SelectableElement):
	selected_actions[slot_node.id] = element.name
	UIManager.predict_player_stance(selected_actions)

func get_troops() -> Array[SelectableElement]:
	var elements = actions.duplicate()
	elements.push_front(empty_unit)
	
	return elements
