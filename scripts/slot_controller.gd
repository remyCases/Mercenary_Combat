extends Control

signal element_selected(slot_node: Node, element_id: SelectableElement)

@onready var main_node: MainMenu = $"/root/Control"
var troops: Array[SelectableElement]
var empty_unit := SelectableElement.new("empty", load("res://images/redcross.png"))

func _init() -> void:
	for i in Globals.OPPONENTS:
		troops.append(SelectableElement.new(i, Globals.OPPONENTS[i].icon))

func _ready() -> void:
	element_selected.connect(_on_element_selected)

func _on_element_selected(_slot_node: Node, element: SelectableElement) -> void:
	if element != empty_unit:
		main_node.enable(element.name)
	else:
		main_node.disable()


func get_troops() -> Array[SelectableElement]:
	var elements = troops.duplicate()
	elements.push_front(empty_unit)
	
	return elements
